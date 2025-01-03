import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as dev;
import 'dart:io';

class WifiNetworkScreen extends StatefulWidget {
  const WifiNetworkScreen({super.key});

  @override
  State<WifiNetworkScreen> createState() => _WifiNetworkScreenState();
}

class _WifiNetworkScreenState extends State<WifiNetworkScreen> {
  final _networkInfo = NetworkInfo();
  String? _wifiName;
  List<String> _availableNetworks = [];
  bool _isScanning = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWifi();
  }

  Future<void> _initializeWifi() async {
    try {
      // Request location permission (required for WiFi scanning)
      final status = await Permission.location.request();
      if (!status.isGranted) {
        setState(() => _errorMessage = 'Location permission required for WiFi scanning');
        return;
      }

      await _scanNetworks();
    } catch (e) {
      dev.log('Error initializing WiFi: $e');
      setState(() => _errorMessage = 'Error initializing WiFi: $e');
    }
  }

  Future<void> _scanNetworks() async {
    try {
      setState(() {
        _isScanning = true;
        _errorMessage = null;
        _availableNetworks.clear();
      });

      // Request location permission if not already granted
      final status = await Permission.location.request();
      if (!status.isGranted) {
        setState(() {
          _errorMessage = 'Location permission is required to scan WiFi networks';
          _isScanning = false;
        });
        return;
      }

      // Get current WiFi name
      _wifiName = await _networkInfo.getWifiName();
      
      // On Android, we can get the WiFi scan results
      if (Platform.isAndroid) {
        final List<WifiNetwork> networks = await _networkInfo.getWifiList() ?? [];
        setState(() {
          _availableNetworks = networks.map((network) => network.ssid).toList();
          _isScanning = false;
        });
      } 
      // On iOS, we can only get the current network due to platform limitations
      else if (Platform.isIOS) {
        if (_wifiName != null) {
          setState(() {
            _availableNetworks = [_wifiName!.replaceAll('"', '')];
            _isScanning = false;
          });
        }
      }

      if (_availableNetworks.isEmpty) {
        setState(() {
          _errorMessage = 'No networks found';
          _isScanning = false;
        });
      }
    } catch (e) {
      dev.log('Error scanning networks: $e');
      setState(() {
        _errorMessage = 'Error scanning networks: $e';
        _isScanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button and title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Networks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Network list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _isScanning
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _availableNetworks.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final network = _availableNetworks[index];
                            return ListTile(
                              title: Text(
                                network,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lock, size: 20),
                                  SizedBox(width: 8),
                                  Icon(Icons.wifi, size: 20),
                                ],
                              ),
                              onTap: () {
                                // Handle network selection
                                showDialog(
                                  context: context,
                                  builder: (context) => _buildPasswordDialog(network),
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordDialog(String networkName) {
    final passwordController = TextEditingController();
    
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
            // Handle WiFi connection
            Navigator.pop(context);
          },
          child: const Text('Connect'),
        ),
      ],
    );
  }
} 