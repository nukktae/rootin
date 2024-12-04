import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:developer' as dev;
import '../screens/final_step_screen.dart';
import '../utils/permission_handler.dart';

class WifiCredentialScreen extends StatefulWidget {
  final BluetoothDevice device;
  final String plantNickname;
  final String imageUrl;

  const WifiCredentialScreen({
    super.key,
    required this.device,
    required this.plantNickname,
    required this.imageUrl,
  });

  @override
  State<WifiCredentialScreen> createState() => _WifiCredentialScreenState();
}

class _WifiCredentialScreenState extends State<WifiCredentialScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  List<String> availableNetworks = [];
  String? selectedNetwork;
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkAndRequestPermissions() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      setState(() => _hasLocationPermission = true);
      _fetchWifiNetworks();
    } else {
      setState(() {
        _hasLocationPermission = false;
        _errorMessage = 'Location permission is required to scan WiFi networks';
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    try {
      final hasPermission = await PermissionUtils.requestLocationPermission();
      
      if (hasPermission) {
        setState(() {
          _hasLocationPermission = true;
          _errorMessage = null;
        });
        _fetchWifiNetworks();
      } else {
        setState(() {
          _errorMessage = 'Location permission is required to scan WiFi networks';
          _hasLocationPermission = false;
        });
      }
    } catch (e) {
      dev.log('Error requesting permission: $e');
      setState(() {
        _errorMessage = 'Error requesting permission: $e';
        _hasLocationPermission = false;
      });
    }
  }

  Future<void> _fetchWifiNetworks() async {
    if (!_hasLocationPermission) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final services = await widget.device.discoverServices();
      BluetoothCharacteristic? targetCharacteristic;

      for (var service in services) {
        if (service.uuid.toString().toLowerCase() == '12345678-1234-5678-1234-56789abcdef0') {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toLowerCase() == '12345678-1234-5678-1234-56789abcdef2') {
              targetCharacteristic = characteristic;
              break;
            }
          }
        }
      }

      if (targetCharacteristic == null) {
        throw Exception('WiFi networks characteristic not found');
      }

      // Read available networks
      final data = await targetCharacteristic.read();
      final networkList = utf8.decode(data);
      dev.log('Available networks: $networkList');

      setState(() {
        availableNetworks = List<String>.from(jsonDecode(networkList));
        _isLoading = false;
      });
    } catch (e) {
      dev.log('Error fetching networks: $e');
      setState(() {
        _errorMessage = 'Failed to fetch networks. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _sendWiFiCredentials() async {
    if (selectedNetwork == null || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please select a network and enter password');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final services = await widget.device.discoverServices();
      BluetoothCharacteristic? targetCharacteristic;

      for (var service in services) {
        if (service.uuid.toString().toLowerCase() == '12345678-1234-5678-1234-56789abcdef0') {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid.toString().toLowerCase() == '12345678-1234-5678-1234-56789abcdef1') {
              targetCharacteristic = characteristic;
              break;
            }
          }
        }
      }

      if (targetCharacteristic == null) {
        throw Exception('WiFi characteristic not found');
      }

      // Enable notifications for connection status
      await targetCharacteristic.setNotifyValue(true);
      
      // Listen for connection status
      targetCharacteristic.value.listen((value) {
        if (value.isNotEmpty) {
          if (value[0] == 0x02) { // Success
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FinalStepScreen(
                  plantNickname: widget.plantNickname,
                  sensorId: widget.device.platformName,
                  networkName: selectedNetwork!,
                  imageUrl: widget.imageUrl,
                ),
              ),
            );
          } else if (value[0] == 0x03) { // Failed
            if (!mounted) return;
            setState(() {
              _errorMessage = 'Failed to connect to WiFi network';
              _isLoading = false;
            });
          }
        }
      });

      // Send WiFi credentials
      final credentials = '$selectedNetwork,${_passwordController.text}';
      await targetCharacteristic.write(
        utf8.encode(credentials),
        withoutResponse: false,
      );
      dev.log('Sent credentials for network: $selectedNetwork');

      // Set timeout for response
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted && _isLoading) {
          setState(() {
            _errorMessage = 'Connection timeout. Please try again.';
            _isLoading = false;
          });
        }
      });

    } catch (e) {
      dev.log('Error sending credentials: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to send credentials: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select a Wi-Fi Network',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              if (!_hasLocationPermission) ...[
                Text(
                  _errorMessage ?? 'Location permission is required to scan WiFi networks',
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _requestLocationPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Grant Location Permission',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ] else if (_isLoading) ...[
                const Center(child: CircularProgressIndicator()),
              ] else ...[
                if (availableNetworks.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const Text('No networks found'),
                        ElevatedButton(
                          onPressed: _fetchWifiNetworks,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: availableNetworks.length,
                      itemBuilder: (context, index) {
                        final network = availableNetworks[index];
                        return ListTile(
                          title: Text(network),
                          selected: selectedNetwork == network,
                          onTap: () {
                            setState(() => selectedNetwork = network);
                          },
                        );
                      },
                    ),
                  ),
                if (selectedNetwork != null) ...[
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedNetwork == null ? null : _sendWiFiCredentials,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Connect',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
