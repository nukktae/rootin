import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/wifi_network_list_modal.dart';

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
        child: Stack(
          children: [
            // Gray container background
            Positioned(
              top: MediaQuery.of(context).size.height * 0.45,
              left: 0,
              right: 0,
              bottom: -30,
              child: Image.asset(
                'assets/images/graycontainer.png',
                fit: BoxFit.fill,
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      
                      // Back Button
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),

                      SizedBox(height: constraints.maxHeight * 0.05),

                      // Title and Subtitle
                      const Text(
                        'Connected Sensor!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Now, connect network with your sensor.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6F6F6F),
                          height: 1.5,
                        ),
                      ),

                      const Spacer(),

                      // Sensor Image and Name
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/sensorsearchlogo.png',
                              width: constraints.maxWidth * 0.8,
                              height: constraints.maxHeight * 0.25,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Rootin Sensor 2067',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Buttons at the bottom
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Show loading modal first
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                    height: MediaQuery.of(context).size.height * 0.7,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                    ),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );

                                // Wait for 3 seconds
                                await Future.delayed(const Duration(seconds: 3));

                                // Close loading modal and show WiFi list modal
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => WifiNetworkListModal(
                                      plantNickname: plantNickname,
                                      imageUrl: imageUrl,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Connect Network',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Try again',
                              style: TextStyle(
                                color: Color(0xFF6F6F6F),
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 