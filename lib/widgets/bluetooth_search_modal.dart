import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:developer' as dev;
import 'dart:async';
import '../screens/connected_sensor_screen.dart';

class BluetoothSearchModal extends StatefulWidget {
  final String plantNickname;
  final String imageUrl;

  const BluetoothSearchModal({
    super.key,
    required this.plantNickname,
    required this.imageUrl,
  });

  @override
  State<BluetoothSearchModal> createState() => _BluetoothSearchModalState();
}

class _BluetoothSearchModalState extends State<BluetoothSearchModal> {
  List<ScanResult> devices = [];
  bool isScanning = false;
  String? errorMessage;
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeBluetooth() async {
    try {
      if (await FlutterBluePlus.isSupported == false) {
        setState(() => errorMessage = 'Bluetooth is not supported on this device');
        return;
      }

      if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
        await FlutterBluePlus.turnOn();
      }

      _startScan();
    } catch (e) {
      dev.log('Error initializing Bluetooth: $e');
      setState(() => errorMessage = 'Error initializing Bluetooth: $e');
    }
  }

  Future<void> _startScan() async {
    try {
      setState(() {
        isScanning = true;
        errorMessage = null;
        devices.clear();
      });

      _scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          if (mounted) {
            setState(() {
              devices = results.where((result) => 
                result.device.platformName.isNotEmpty
              ).toList();
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
        }
      );

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        androidUsesFineLocation: false,
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

  Future<void> _refreshScan() async {
    if (!isScanning) {
      devices.clear();
      await _startScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.93,
      clipBehavior: Clip.antiAlias,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Devices in Range',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _refreshScan,
                ),
              ],
            ),
          ),

          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),

          ElevatedButton(
            onPressed: isScanning ? null : _startScan,
            child: Text(isScanning ? 'Scanning...' : 'Scan for Devices'),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF2F2F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: isScanning
                    ? const Center(child: CircularProgressIndicator())
                    : devices.isEmpty
                        ? const Center(child: Text('No devices found'))
                        : ListView.builder(
                            itemCount: devices.length,
                            itemBuilder: (context, index) {
                              final device = devices[index].device;
                              return ListTile(
                                title: Text(
                                  device.platformName.isNotEmpty
                                      ? device.platformName
                                      : 'Unknown Device',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: TextButton(
                                  onPressed: () => _connectToDevice(device),
                                  child: const Text('Connect'),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      if (mounted) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectedSensorScreen(
              device: device,
              plantNickname: widget.plantNickname,
              imageUrl: widget.imageUrl,
            ),
          ),
        );
      }
    } catch (e) {
      dev.log('Failed to connect: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to connect: $e')),
        );
      }
    }
  }
} 