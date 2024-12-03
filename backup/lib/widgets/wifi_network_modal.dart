import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as dev;
import 'dart:async';
import 'dart:io' show Platform;
import 'dart:convert' show utf8;
import '../screens/final_step_screen.dart';
import '../services/wifi_service.dart';

class WifiNetworkModal extends StatefulWidget {
  final String plantNickname;
  final String imageUrl;
  final BluetoothDevice device;

  const WifiNetworkModal({
    super.key,
    required this.plantNickname,
    required this.imageUrl,
    required this.device,
  });

  @override
  State<WifiNetworkModal> createState() => _WifiNetworkModalState();
}

class _WifiNetworkModalState extends State<WifiNetworkModal> {
  bool isScanning = false;
  String? errorMessage;
  List<String> _networks = [];
  final _networkInfo = NetworkInfo();
  BluetoothDevice? connectedDevice;
  StreamSubscription? valueSubscription;
  BluetoothCharacteristic? targetCharacteristic;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndScan();
  }

  @override
  void dispose() {
    valueSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkPermissionAndScan() async {
    if (!mounted) return;

    try {
      if (Platform.isAndroid) {
        final locationStatus = await Permission.locationWhenInUse.request();
        if (!locationStatus.isGranted) {
          throw Exception('Location permission required for WiFi scanning');
        }
      }

      setState(() {
        isScanning = true;
        errorMessage = null;
        _networks.clear();
      });

      await _getNetworksFromSensor();
    } catch (e) {
      dev.log('Permission/scanning error: $e');
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isScanning = false;
        });
      }
    }
  }

  Future<void> _getNetworksFromSensor() async {
    try {
      dev.log('Starting network scan...');
      setState(() {
        isScanning = true;
        errorMessage = null;
        _networks.clear();
      });

      final networks = await WifiService.getAvailableNetworks();
      
      if (networks.isNotEmpty) {
        setState(() {
          _networks = networks;
          isScanning = false;
        });
      } else {
        await _getNetworksFromBLE();
      }

    } catch (e) {
      dev.log('Error scanning networks: $e');
      if (mounted) {
        setState(() {
          errorMessage = 'Error scanning networks: $e';
          isScanning = false;
        });
      }
    }
  }

  Future<void> _getNetworksFromBLE() async {
    try {
      List<BluetoothService> services = await widget.device.discoverServices();
      bool foundService = false;
      
      for (var service in services) {
        if (service.uuid.toString().toLowerCase() == '12345678-1234-5678-1234-56789abcdef0') {
          foundService = true;
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toLowerCase() == '12345678-1234-5678-1234-56789abcdef1') {
              targetCharacteristic = characteristic;
              
              // Enable notifications first
              await characteristic.setNotifyValue(true);
              dev.log('Notifications enabled for network scan');
              
              // Set up notification listener before writing
              valueSubscription?.cancel(); // Cancel any existing subscription
              valueSubscription = characteristic.value.listen(
                (value) {
                  if (value.isNotEmpty) {
                    try {
                      String response = utf8.decode(value);
                      dev.log('Received from sensor: $response');
                      
                      if (response == '2') {
                        if (mounted) {
                          setState(() {
                            errorMessage = 'Failed to scan networks';
                            isScanning = false;
                          });
                        }
                      } else if (response != '0' && response != '1') {
                        // Split network list and update UI
                        if (mounted) {
                          final bleNetworks = response.split(',')
                            .where((network) => network.isNotEmpty && network.trim().isNotEmpty)
                            .map((network) => network.trim())
                            .toList();
                          
                          if (bleNetworks.isNotEmpty) {
                            setState(() {
                              _networks = bleNetworks;
                              isScanning = false;
                              errorMessage = null;
                            });
                          } else {
                            setState(() {
                              errorMessage = 'No networks found';
                              isScanning = false;
                            });
                          }
                        }
                      }
                    } catch (e) {
                      dev.log('Error decoding response: $e');
                      if (mounted) {
                        setState(() {
                          errorMessage = 'Error decoding network list';
                          isScanning = false;
                        });
                      }
                    }
                  }
                },
                onError: (error) {
                  dev.log('Network scan error: $error');
                  if (mounted) {
                    setState(() {
                      errorMessage = 'Failed to scan networks: $error';
                      isScanning = false;
                    });
                  }
                },
              );
              
              // Request network scan after setting up listener
              await characteristic.write(
                utf8.encode('SCAN'),
                withoutResponse: false
              );
              dev.log('Sent SCAN command to sensor');
              
              // Set a timeout
              Future.delayed(const Duration(seconds: 10), () {
                if (mounted && isScanning) {
                  setState(() {
                    errorMessage = 'Network scan timeout';
                    isScanning = false;
                  });
                }
              });
              
              return;
            }
          }
        }
      }
      
      if (!foundService) {
        throw Exception('Required BLE service not found');
      }
    } catch (e) {
      dev.log('Error in BLE scan: $e');
      if (mounted) {
        setState(() {
          errorMessage = 'Error scanning networks: $e';
          isScanning = false;
        });
      }
    }
  }

  Future<void> _connectToNetwork(String networkName, String password) async {
    StreamSubscription? valueSubscription;
    bool isConnecting = true;
    Timer? timeoutTimer;
    
    try {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Connecting to network...'),
                ],
              ),
            );
          },
        );
      }

      List<BluetoothService> services = await widget.device.discoverServices();
      
      for (var service in services) {
        if (service.uuid.toString().toLowerCase() == '12345678-1234-5678-1234-56789abcdef0') {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toLowerCase() == '12345678-1234-5678-1234-56789abcdef1') {
              targetCharacteristic = characteristic;
              
              // Enable notifications
              await characteristic.setNotifyValue(true);
              dev.log('Notifications enabled');

              // Send credentials
              final credentials = '$networkName,$password';
              await characteristic.write(
                utf8.encode(credentials),
                withoutResponse: false  // Use write-with-response like Python
              );
              dev.log('Credentials sent: $credentials');

              // Poll for response like Python code
              Timer.periodic(const Duration(seconds: 1), (timer) async {
                if (!isConnecting) {
                  timer.cancel();
                  return;
                }

                try {
                  List<int> response = await characteristic.read();
                  String responseStr = utf8.decode(response);
                  dev.log('Received response: $responseStr');

                  if (responseStr == '2') {
                    timer.cancel();
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to connect to network'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else if (responseStr == '1') {
                    timer.cancel();
                    if (mounted) {
                      Navigator.pop(context);
                      // Wait for ID response
                      valueSubscription = characteristic.value.listen(
                        (value) {
                          if (value.isNotEmpty) {
                            String idResponse = utf8.decode(value);
                            if (idResponse.startsWith('ID:')) {
                              final receivedId = idResponse.substring(3).trim();
                              if (receivedId.isNotEmpty && mounted) {
                                isConnecting = false;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FinalStepScreen(
                                      plantNickname: widget.plantNickname,
                                      imageUrl: widget.imageUrl,
                                      sensorId: receivedId,
                                      networkName: networkName,
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        },
                      );
                    }
                  }
                } catch (e) {
                  dev.log('Error reading response: $e');
                }
              });

              // Set timeout
              timeoutTimer = Timer(const Duration(seconds: 30), () {
                if (isConnecting && mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Connection timeout - please try again'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              });
              
              return;
            }
          }
        }
      }
      
      throw Exception('Required BLE service not found');
    } catch (e) {
      dev.log('Error connecting to network: $e');
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (isConnecting) {
        timeoutTimer?.cancel();
        valueSubscription?.cancel();
        try {
          if (targetCharacteristic != null && widget.device.isConnected) {
            await targetCharacteristic!.setNotifyValue(false);
          }
        } catch (e) {
          dev.log('Error cleaning up: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Networks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          if (errorMessage != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _checkPermissionAndScan,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.purple,
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

          Expanded(
            child: isScanning
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _networks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.wifi),
                        title: Text(_networks[index]),
                        trailing: const Icon(Icons.lock, size: 20),
                        onTap: () => _showPasswordDialog(_networks[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showPasswordDialog(String networkName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController passwordController = TextEditingController();
        return AlertDialog(
          title: Text('Connect to $networkName'),
          content: TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _connectToNetwork(networkName, passwordController.text);
              },
              child: const Text('Connect'),
            ),
          ],
        );
      },
    );
  }
} 