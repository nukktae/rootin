import 'package:flutter/material.dart';

class RegisterSensorContent extends StatelessWidget {
  const RegisterSensorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How to Register Sensor',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.22,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Follow these steps to register your sensor:',
          style: TextStyle(
            color: Color(0xFF757575),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.28,
          ),
        ),
        const SizedBox(height: 24),
        _buildStep(
          number: '1',
          title: 'Turn on Bluetooth',
          description: 'Enable Bluetooth on your device to connect with the sensor.',
        ),
        _buildStep(
          number: '2',
          title: 'Press the Button',
          description: 'Press the button on your sensor for 3 seconds until the LED blinks.',
        ),
        _buildStep(
          number: '3',
          title: 'Connect',
          description: 'Select your sensor from the list of available devices.',
        ),
      ],
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const ShapeDecoration(
              color: Colors.black,
              shape: CircleBorder(),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 