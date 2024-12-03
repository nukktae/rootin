import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/wifi_network_modal.dart';

class ConnectedSensorScreen extends StatelessWidget {
  final BluetoothDevice device;
  final String plantNickname;
  final String imageUrl;

  const ConnectedSensorScreen({
    super.key,
    required this.device,
    required this.plantNickname,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            const Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Color(0xFFEEEEEE),
                  child: BackButton(color: Colors.black),
                ),
              ),
            ),

            // Title and description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connected Sensor!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.22,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Now, connect network with your sensor.',
                    style: TextStyle(
                      color: Color(0xFF6F6F6F),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),

            // Sensor display area
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/sensorsearchlogo.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      device.platformName.isNotEmpty 
                          ? device.platformName 
                          : 'Unknown Device',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Connect Network button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => WifiNetworkModal(
                            device: device,
                            plantNickname: plantNickname,
                            imageUrl: imageUrl,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Connect Network',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // Add retry logic here
                    },
                    child: const Text(
                      'Try again',
                      style: TextStyle(
                        color: Color(0xFF6F6F6F),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 