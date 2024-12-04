import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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
  List<DeviceItem> devices = [];
  bool isScanning = false;
  String? connectingDevice;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    setState(() {
      isScanning = true;
      devices = [];
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        devices = [
          DeviceItem(name: "Rootin Sensor 2067", status: DeviceStatus.notConnected),
          DeviceItem(name: "My Airpod", status: DeviceStatus.notConnected),
          DeviceItem(name: "F900S", status: DeviceStatus.notConnected),
          DeviceItem(name: "MK-300", status: DeviceStatus.notConnected),
          DeviceItem(name: "NS-01G Pro", status: DeviceStatus.notConnected),
          DeviceItem(name: "QCC3003", status: DeviceStatus.notConnected),
          DeviceItem(name: "R-S202 Yamaha", status: DeviceStatus.notConnected),
        ];
        isScanning = false;
      });
    }
  }

  Future<void> _connectToDevice(DeviceItem device) async {
    setState(() {
      device.status = DeviceStatus.connecting;
    });

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        device.status = DeviceStatus.connected;
      });
      
      // Navigate to ConnectedSensorScreen after successful connection
      if (device.name == "Rootin Sensor 2067") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectedSensorScreen(
              device: MockBluetoothDevice(device.name),
              plantNickname: widget.plantNickname,
              imageUrl: widget.imageUrl,
            ),
          ),
        );
      }
    }
  }

  String _getButtonText(DeviceStatus status) {
    switch (status) {
      case DeviceStatus.connecting:
        return 'Connecting...';
      case DeviceStatus.connected:
        return 'Connected';
      default:
        return 'Connect';
    }
  }

  Color _getButtonColor(DeviceStatus status) {
    switch (status) {
      case DeviceStatus.connecting:
        return Colors.grey;
      case DeviceStatus.connected:
        return Colors.blue;
      default:
        return Colors.black;
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
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Devices in Range',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      device.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: device.status == DeviceStatus.notConnected
                          ? () => _connectToDevice(device)
                          : null,
                      child: Text(
                        _getButtonText(device.status),
                        style: TextStyle(
                          color: _getButtonColor(device.status),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum DeviceStatus {
  notConnected,
  connecting,
  connected,
}

class DeviceItem {
  final String name;
  DeviceStatus status;

  DeviceItem({
    required this.name,
    required this.status,
  });
}

class MockBluetoothDevice extends BluetoothDevice {
  @override
  final String name;
  
  MockBluetoothDevice(this.name) : super(remoteId: DeviceIdentifier('mock_id'));
  
  @override
  String get platformName => name;
  
  @override
  Future<void> connect({
    bool autoConnect = true,
    int? mtu,
    Duration timeout = const Duration(seconds: 35),
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return;
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}