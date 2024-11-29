import 'package:flutter/material.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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

              // Title and Description
              const Text(
                'Final Step!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Check if the plant and sensor\'s connection is correct.\nIf so, press the button below and start your new care!',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6F6F6F),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // Plant Nickname
              Text(
                plantNickname,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),

              const SizedBox(height: 40),

              // Sensor Details
              const Text(
                'Sensor Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6F6F6F),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Network Details
              const Text(
                'Network',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6F6F6F),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Start Care Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to care screen or home screen
                    Navigator.of(context).popUntil((route) => route.isFirst);
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
} 