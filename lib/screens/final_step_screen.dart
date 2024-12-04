import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class FinalStepScreen extends StatelessWidget {
  final String plantNickname;
  final String sensorId;
  final String networkName;
  final String imageUrl;

  const FinalStepScreen({
    super.key,
    required this.plantNickname,
    required this.sensorId,
    required this.networkName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 
                     MediaQuery.of(context).padding.top - 
                     MediaQuery.of(context).padding.bottom,
              child: Column(
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

                  const SizedBox(height: 40),

                  // Title
                  const Text(
                    'Final Step!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0.06,
                      letterSpacing: -0.22,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description
                  const Text(
                    'Check if the plant and sensor\'s connection is correct.\nIf so, press the button below and start your new care!',
                    style: TextStyle(
                      color: Color(0xFF6F6F6F),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0.10,
                      letterSpacing: -0.28,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Plant Image and Name
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          plantNickname,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0.06,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sensor Info Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Sensor Name Section
                        const Text(
                          'Sensor Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0.09,
                            letterSpacing: -0.16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.sensors, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              sensorId,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0.07,
                                letterSpacing: -0.20,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Network Section
                        const Text(
                          'Network',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0.09,
                            letterSpacing: -0.16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.wifi, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              networkName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0.07,
                                letterSpacing: -0.20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Start Care Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              body: HomeScreen(
                                setCurrentIndex: (index) {
                                  // This will be handled by the parent widget
                                },
                              ),
                              bottomNavigationBar: CustomBottomNavigationBar(
                                currentIndex: 0,  // Start at home tab
                                onTap: (index) {
                                  // Handle tab changes
                                },
                              ),
                            ),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start New Care!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0.09,
                          letterSpacing: -0.16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 