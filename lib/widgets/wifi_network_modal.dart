import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:developer' as dev;
import 'dart:async';
import '../screens/final_step_screen.dart';

class WifiNetworkModal extends StatefulWidget {
  final String plantNickname;
  final String imageUrl;

  const WifiNetworkModal({
    super.key,
    required this.plantNickname,
    required this.imageUrl,
  });

  @override
  State<WifiNetworkModal> createState() => _WifiNetworkModalState();
}

class _WifiNetworkModalState extends State<WifiNetworkModal> with WidgetsBindingObserver {
  bool isScanning = false;
  String? errorMessage;
  List<String> _networks = [];
  final _networkInfo = NetworkInfo();
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getNetworksFromSensor();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _getNetworksFromSensor() async {
    if (!mounted) return;

    try {
      setState(() {
        isScanning = true;
        errorMessage = null;
      });

      // Get the list of connected devices
      final connectedDevices = await FlutterBluePlus.connectedDevices;
      if (connectedDevices.isNotEmpty) {
        connectedDevice = connectedDevices.first;
        
        // Get services from the connected device
        final services = await connectedDevice!.discoverServices();
        bool foundNetworks = false;

        for (var service in services) {
          for (var characteristic in service.characteristics) {
            // Replace with your sensor's characteristic UUID
            if (characteristic.uuid.toString() == 'YOUR_WIFI_LIST_CHARACTERISTIC_UUID') {
              final data = await characteristic.read();
              final networks = _parseNetworksFromData(data);
              
              setState(() {
                _networks = networks;
                isScanning = false;
              });
              foundNetworks = true;
              break;
            }
          }
          if (foundNetworks) break;
        }

        if (!foundNetworks) {
          // If we couldn't get networks from the sensor, show dummy networks for now
          setState(() {
            _networks = [
              'Home WiFi',
              'Office Network',
              'Guest Network',
              'IoT Network',
              'Test Network'
            ];
            isScanning = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'No connected sensor found. Please connect a sensor first.';
          isScanning = false;
        });
      }

    } catch (e) {
      dev.log('Error getting networks from sensor: $e');
      if (mounted) {
        setState(() {
          errorMessage = 'Error getting networks from sensor: $e';
          isScanning = false;
        });
      }
    }
  }

  List<String> _parseNetworksFromData(List<int> data) {
    try {
      final networkString = String.fromCharCodes(data);
      return networkString.split(',').where((network) => network.isNotEmpty).toList();
    } catch (e) {
      dev.log('Error parsing network data: $e');
      return [];
    }
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
                Navigator.pop(context); // Close dialog
                // Navigate to final step screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinalStepScreen(
                      plantNickname: widget.plantNickname,
                      sensorId: 'Rootin Sensor 2067',
                      networkName: networkName,
                      imageUrl: widget.imageUrl,
                    ),
                  ),
                );
              },
              child: const Text('Connect'),
            ),
          ],
        );
      },
    );
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
          // Header with close button and title
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
                const SizedBox(width: 40), // For balance
              ],
            ),
          ),

          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),

          // Network list
          Expanded(
            child: isScanning
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _networks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.wifi),
                        title: Text(_networks[index]),
                        onTap: () => _showPasswordDialog(_networks[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
} 