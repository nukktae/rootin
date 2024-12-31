import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';
import 'dart:developer' as dev;
import 'dart:convert' show utf8, json;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectionResult {
  final bool success;
  final String? deviceId;
  
  ConnectionResult({required this.success, this.deviceId});
}

class BleService {
  static final BleService _instance = BleService._internal();
  factory BleService() => _instance;
  
  BleService._internal() {
    _initializeController();
  }

  final _ble = FlutterReactiveBle();
  StreamSubscription<ConnectionStateUpdate>? _connection;
  QualifiedCharacteristic? _characteristic;
  late StreamController<ConnectionResult> _connectionController;
  bool _bleInitialized = false;
  bool _notificationsEnabled = false;
  bool _isDisconnecting = false;
  DateTime? _lastDisconnectTime;
  DeviceConnectionState _connectionState = DeviceConnectionState.disconnected;
  StreamSubscription? _notificationSubscription;

  // Constants
  static const Duration _writeResponseDelay = Duration(milliseconds: 500);
  static const Duration _unsubscribeDelay = Duration(seconds: 1);
  static const Duration _iosOperationTimeout = Duration(seconds: 8);
  static const int _iosMaxRetries = 3;
  
  final _serviceUuid = Uuid.parse('12345678-1234-5678-1234-56789abcdef0');
  final _charUuid = Uuid.parse('12345678-1234-5678-1234-56789abcdef1');

  Future<void> initialize() async {
    if (_bleInitialized) return;
    
    try {
      if (await FlutterBluePlus.isSupported == false) {
        throw Exception('Bluetooth is not supported on this device');
      }

      if (Platform.isIOS) {
        dev.log('Checking iOS permissions...');
        
        // First check system location services
        final locationService = await Permission.location.serviceStatus;
        dev.log('Location service status: $locationService');
        
        if (!locationService.isEnabled) {
          dev.log('Location services disabled at system level');
          throw Exception('Please enable Location Services:\n\n1. Open iOS Settings\n2. Go to Privacy & Security\n3. Tap Location Services\n4. Turn on Location Services');
        }

        // Request location permission with retry logic
        for (int i = 0; i < 3; i++) {
          var locationStatus = await Permission.locationWhenInUse.status;
          dev.log('Location permission status (attempt ${i + 1}): $locationStatus');
          
          if (locationStatus.isGranted) {
            break;
          }
          
          if (i == 2 && !locationStatus.isGranted) {
            throw Exception('Location permission is required. Please enable it in Settings.');
          }

          locationStatus = await Permission.locationWhenInUse.request();
          await Future.delayed(const Duration(seconds: 1));
        }

        // Now check Bluetooth permission
        var bluetoothStatus = await Permission.bluetooth.status;
        dev.log('Bluetooth permission status: $bluetoothStatus');

        if (!bluetoothStatus.isGranted) {
          bluetoothStatus = await Permission.bluetooth.request();
          await Future.delayed(const Duration(seconds: 1));
          
          if (!bluetoothStatus.isGranted) {
            throw Exception('Bluetooth permission is required');
          }
        }

        // Final verification
        final finalLocationStatus = await Permission.locationWhenInUse.status;
        final finalBluetoothStatus = await Permission.bluetooth.status;
        final finalLocationService = await Permission.location.serviceStatus;

        dev.log('Final status - Location: $finalLocationStatus, Bluetooth: $finalBluetoothStatus, LocationService: $finalLocationService');

        if (!finalLocationStatus.isGranted || 
            !finalBluetoothStatus.isGranted || 
            !finalLocationService.isEnabled) {
          throw Exception('Required permissions are not granted. Please check Settings.');
        }

        // Check if Bluetooth is on
        final bluetoothState = await FlutterBluePlus.adapterState.first;
        if (bluetoothState != BluetoothAdapterState.on) {
          throw Exception('Please turn on Bluetooth in Settings to continue');
        }
      }

      _bleInitialized = true;
      dev.log('BLE initialized successfully');
    } catch (e) {
      _bleInitialized = false;
      dev.log('BLE initialization failed: $e');
      rethrow;
    }
  }

  Future<T> _withTimeout<T>(Future<T> Function() operation) async {
    if (Platform.isIOS) {
      return await operation().timeout(
        _iosOperationTimeout,
        onTimeout: () => throw Exception('BLE operation timed out on iOS'),
      );
    }
    return await operation();
  }

  Future<void> _writeWithRetry(List<int> data) async {
    if (_characteristic == null) throw Exception('Characteristic not set up');
    
    int retries = Platform.isIOS ? _iosMaxRetries : 1;
    
    while (retries > 0) {
      try {
        await _withTimeout(() => 
          _ble.writeCharacteristicWithResponse(
            _characteristic!,
            value: data,
          )
        );
        break;
      } catch (e) {
        retries--;
        if (retries == 0) rethrow;
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  void _initializeController() {
    _connectionController = StreamController<ConnectionResult>.broadcast();
  }

  Stream<ConnectionResult> get connectionStream => _connectionController.stream;

  Future<void> connect(String deviceId) async {
    // Clean up any existing connection first
    await disconnect();
    
    if (!_bleInitialized) {
      await initialize();
      if (!_bleInitialized) {
        throw Exception('BLE not initialized - check permissions and Bluetooth status');
      }
    }

    // Re-initialize the controller if it's closed
    if (_connectionController.isClosed) {
      _initializeController();
    }

    dev.log('Connecting to device: $deviceId');
    _connection = _ble.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    ).listen(
      (state) async {
        _connectionState = state.connectionState;
        dev.log('Connection state: ${state.connectionState}');
        
        if (state.connectionState == DeviceConnectionState.connected) {
          try {
            await _setupCharacteristic(deviceId);
            if (!_connectionController.isClosed) {
              _connectionController.add(ConnectionResult(success: true, deviceId: deviceId));
            }
          } catch (e) {
            dev.log('Error setting up characteristic: $e');
            if (!_connectionController.isClosed) {
              _connectionController.add(ConnectionResult(success: false));
            }
            await disconnect();
          }
        } else if (state.connectionState == DeviceConnectionState.disconnected) {
          if (!_connectionController.isClosed) {
            _connectionController.add(ConnectionResult(success: false));
          }
        }
      },
      onError: (error) {
        dev.log('Connection error: $error');
        _cleanupSubscriptions();
        if (!_connectionController.isClosed) {
          _connectionController.add(ConnectionResult(success: false));
        }
      },
    );
  }

  Future<void> disconnect() async {
    if (_connectionState == DeviceConnectionState.disconnected) {
      return;
    }
    
    _isDisconnecting = true;
    try {
      await _cleanupSubscriptions();
      _characteristic = null;
      _lastDisconnectTime = DateTime.now();
    } finally {
      _isDisconnecting = false;
    }
  }

  Future<void> _enableNotifications() async {
    if (_characteristic == null || _notificationsEnabled) return;
    
    try {
      await _ble.writeCharacteristicWithResponse(
        _characteristic!,
        value: [0x01],
      );
      _notificationsEnabled = true;
      dev.log('Notifications enabled');
    } catch (e) {
      dev.log('Error enabling notifications: $e');
      throw Exception('Failed to enable notifications');
    }
  }

  Future<void> _disableNotifications() async {
    if (_characteristic == null || !_notificationsEnabled) return;
    
    try {
      await _ble.writeCharacteristicWithResponse(
        _characteristic!,
        value: [0x00],
      );
      _notificationsEnabled = false;
      dev.log('Notifications disabled');
    } catch (e) {
      dev.log('Error disabling notifications: $e');
    }
  }

  Future<void> _cleanupSubscriptions() async {
    try {
      if (_connectionState == DeviceConnectionState.connected && 
          _characteristic != null && 
          _notificationsEnabled) {
        try {
          // Disable notifications
          await _writeWithCheck([0x00]);
          _notificationsEnabled = false;
          dev.log('Notifications disabled');
          
          // Wait before unsubscribing
          await Future.delayed(_unsubscribeDelay);
        } catch (e) {
          dev.log('Error disabling notifications: $e');
        }
      }
      
      if (_notificationSubscription != null) {
        await _notificationSubscription?.cancel();
        _notificationSubscription = null;
        dev.log('Notification subscription cancelled');
      }

      if (_connection != null) {
        await _connection?.cancel();
        _connection = null;
        dev.log('Connection subscription cancelled');
      }
    } catch (e) {
      dev.log('Error in cleanup process: $e');
    } finally {
      _notificationsEnabled = false;
      _connectionState = DeviceConnectionState.disconnected;
    }
  }

  Stream<ConnectionResult> listenForConnectionResult() {
    if (_characteristic == null) {
      throw Exception('Characteristic not set up');
    }

    _notificationSubscription?.cancel();
    _notificationSubscription = null;

    return _ble.subscribeToCharacteristic(_characteristic!).map((data) {
      final response = utf8.decode(data);
      dev.log('Connection response: $response');
      
      if (response == '2') {
        return ConnectionResult(success: false);
      } else if (response == '1') {
        return ConnectionResult(success: true);
      } else if (response.startsWith('ID:')) {
        return ConnectionResult(
          success: true,
          deviceId: response.substring(3).trim(),
        );
      }
      return ConnectionResult(success: false);
    });
  }

  Future<void> _setupCharacteristic(String deviceId) async {
    _characteristic = QualifiedCharacteristic(
      serviceId: _serviceUuid,
      characteristicId: _charUuid,
      deviceId: deviceId,
    );
  }

  Future<void> sendWifiCredentials(String ssid, String password) async {
    if (_characteristic == null) {
      throw Exception('Characteristic not set up');
    }

    final credentials = json.encode({
      'ssid': ssid,
      'password': password
    });

    try {
      await _writeWithCheck(utf8.encode(credentials));
      dev.log('Credentials sent successfully');
    } catch (e) {
      dev.log('Error sending credentials: $e');
      throw Exception('Failed to send credentials: $e');
    }
  }

  Future<List<String>> scanNetworks() async {
    if (!_bleInitialized) {
      await initialize();
      if (!_bleInitialized) {
        throw Exception('BLE not initialized - check permissions and Bluetooth status');
      }
    }

    if (_characteristic == null) {
      throw Exception('Device not connected - please connect first');
    }

    try {
      // Clean up existing subscriptions
      await _cleanupSubscriptions();
      
      // Enable notifications
      await _enableNotifications();
      
      // Send scan command
      await _writeWithRetry(utf8.encode('SCAN'));
      dev.log('Sent SCAN command');

      final completer = Completer<List<String>>();
      final networks = <String>[];
      Timer? timeoutTimer;

      _notificationSubscription = _ble.subscribeToCharacteristic(_characteristic!)
        .timeout(
          const Duration(seconds: 15),
          onTimeout: (sink) {
            if (!completer.isCompleted) {
              completer.complete(networks);
            }
          },
        )
        .listen(
          (data) {
            timeoutTimer?.cancel();
            try {
              final response = utf8.decode(data);
              if (response == '2') {
                if (!completer.isCompleted) {
                  completer.completeError('Failed to scan networks');
                }
                return;
              }
              
              final networkList = response.split(',')
                .where((n) => n.isNotEmpty && n.trim().isNotEmpty)
                .toList();
                
              if (networkList.isNotEmpty) {
                networks.addAll(networkList);
                if (!completer.isCompleted) {
                  completer.complete(networks);
                }
              }
            } catch (e) {
              dev.log('Error processing network data: $e');
            }
          },
          onError: (error) {
            timeoutTimer?.cancel();
            if (!completer.isCompleted) {
              completer.completeError('Failed to scan networks: $error');
            }
          },
        );

      timeoutTimer = Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          completer.complete(networks);
        }
      });

      return completer.future;
    } catch (e) {
      dev.log('Error in scanNetworks: $e');
      throw Exception('Failed to scan networks: $e');
    }
  }

  Future<void> _writeWithCheck(List<int> data) async {
    if (_characteristic == null) {
      throw Exception('Characteristic not set up');
    }

    try {
      await _ble.writeCharacteristicWithResponse(
        _characteristic!,
        value: data,
      );
      // Wait for device to process the write
      await Future.delayed(_writeResponseDelay);
    } catch (e) {
      dev.log('Error writing to characteristic: $e');
      throw Exception('Failed to write to characteristic: $e');
    }
  }

  bool _isValidJson(String str) {
    try {
      json.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _cleanupSubscriptions();
    if (!_connectionController.isClosed) {
      _connectionController.close();
    }
  }

  Future<void> _requestLocationPermission() async {
    // Check system location services first
    final locationService = await Permission.location.serviceStatus;
    dev.log('System location services status: $locationService');
    
    if (!locationService.isEnabled) {
      throw Exception('Please enable Location Services in iOS Settings');
    }

    // Request location permission with retry
    var locationStatus = await Permission.locationWhenInUse.status;
    if (!locationStatus.isGranted) {
      // Show alert before requesting permission
      locationStatus = await Permission.locationWhenInUse.request();
      await Future.delayed(const Duration(seconds: 2));
      
      // Check again after request
      locationStatus = await Permission.locationWhenInUse.status;
      if (!locationStatus.isGranted) {
        throw Exception('Location permission is required for Bluetooth scanning');
      }
    }

    // Final verification
    final finalLocationService = await Permission.location.serviceStatus;
    if (!finalLocationService.isEnabled) {
      throw Exception('Location Services must be enabled to continue');
    }
  }
} 