import 'package:flutter/material.dart';

class FAQContent extends StatelessWidget {
  const FAQContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.22,
          ),
        ),
        const SizedBox(height: 24),
        _buildFAQItem(
          question: 'How often should I water my plant?',
          answer: 'Watering frequency depends on your plant type, environment, and season. The app will notify you when it\'s time to water based on soil moisture readings.',
        ),
        _buildFAQItem(
          question: 'What if my sensor disconnects?',
          answer: 'Try moving closer to the sensor and ensure Bluetooth is enabled. If issues persist, try removing and reinserting the battery.',
        ),
        _buildFAQItem(
          question: 'How accurate are the readings?',
          answer: 'Our sensors are calibrated to provide accurate readings within ±3% for soil moisture. Environmental factors may slightly affect readings.',
        ),
        _buildFAQItem(
          question: 'How long does the battery last?',
          answer: 'The sensor battery typically lasts 6-12 months with normal use. The app will notify you when battery levels are low.',
        ),
      ],
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              color: Color(0xFF757575),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
          ),
        ],
      ),
    );
  }
} 