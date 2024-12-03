import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:developer' as dev;
import 'dart:async';

import '../screens/wifi_credential_screen.dart';

class BluetoothSearchScreen extends StatefulWidget {
  final String plantNickname;
  final String imageUrl;

  const BluetoothSearchScreen({
    super.key,
    required this.plantNickname,
    required this.imageUrl,
  });

  @override
  State<BluetoothSearchScreen> createState() => _BluetoothSearchScreenState();
}

class _BluetoothSearchScreenState extends State<BluetoothSearchScreen> {
  List<ScanResult> devices = [];
  bool isScanning = false;
  String? errorMessage;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _connectionStateSubscription;
  StreamSubscription? _valueSubscription;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _valueSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startScan() async {
    try {
      setState(() {
        isScanning = true;
        errorMessage = null;
        devices.clear();
      });

      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      _scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          if (mounted) {
            setState(() {
              devices = results
                  .where((result) =>
                      result.device.platformName.isNotEmpty &&
                      result.device.platformName.startsWith('Rootin'))
                  .toList();
            });
          }
        },
        onError: (e) {
          dev.log('Scan error: $e');
          if (mounted) {
            setState(() {
              errorMessage = 'Scan error: $e';
              isScanning = false;
            });
          }
        },
      );

      Future.delayed(const Duration(seconds: 10), () {
        if (mounted) {
          setState(() => isScanning = false);
        }
      });
    } catch (e) {
      dev.log('Error starting scan: $e');
      if (mounted) {
        setState(() {
          errorMessage = 'Error starting scan: $e';
          isScanning = false;
        });
      }
    }
  }

  Future<void> _connectToDevice(BuildContext context, BluetoothDevice device) async {
    if (_isConnecting) return;
    
    setState(() {
      _isConnecting = true;
      errorMessage = null;
    });

    BuildContext? dialogContext;

    try {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return const PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text('Connecting...'),
              content: CircularProgressIndicator(),
            ),
          );
        },
      );

      dev.log('Connecting to device...');
      await device.connect(timeout: const Duration(seconds: 5));
      
      if (!device.isConnected) {
        throw Exception('Failed to establish connection');
      }

      dev.log('Discovering services...');
      List<BluetoothService> services = await device.discoverServices();
      
      bool foundService = false;
      for (var service in services) {
        dev.log('Found service: ${service.uuid}');
        
        if (service.uuid.toString().toLowerCase() == '12345678-1234-5678-1234-56789abcdef0') {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toLowerCase() == '12345678-1234-5678-1234-56789abcdef1') {
              foundService = true;
              
              await characteristic.setNotifyValue(true);
              
              await characteristic.write([0x01], withoutResponse: false);
              
              if (!mounted) return;
              if (dialogContext != null) {
                Navigator.pop(dialogContext!);
              }
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WifiCredentialScreen(
                    device: device,
                    plantNickname: widget.plantNickname,
                    imageUrl: widget.imageUrl,
                  ),
                ),
              );
              break;
            }
          }
          if (foundService) break;
        }
      }
      
      if (!foundService) {
        throw Exception('Required service not found');
      }

    } catch (e) {
      dev.log('Connection error: $e');
      if (mounted && dialogContext != null) {
        Navigator.pop(dialogContext!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      try {
        await device.disconnect();
      } catch (disconnectError) {
        dev.log('Error disconnecting: $disconnectError');
      }
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Available Devices',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              ),
            Expanded(
              child: isScanning
                  ? const Center(child: CircularProgressIndicator())
                  : devices.isEmpty
                      ? const Center(child: Text("No devices found. Try scanning again."))
                      : ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            final device = devices[index].device;
                            return ListTile(
                              title: Text(device.platformName),
                              subtitle: Text(device.remoteId.toString()),
                              trailing: TextButton(
                                onPressed: _isConnecting ? null : () => _connectToDevice(context, device),
                                child: const Text('Connect'),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : _startScan,
        child: Icon(isScanning ? Icons.stop : Icons.refresh),
      ),
    );
  }
}
