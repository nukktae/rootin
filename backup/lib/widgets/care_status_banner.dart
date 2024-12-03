import 'package:flutter/material.dart';
import 'care_status_icon.dart'; // Separate StatusIcon widget for CareScreen

class CareStatusBanner extends StatelessWidget {
  final String status;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onButtonPressed;

  const CareStatusBanner({
    super.key,
    required this.status,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CareStatusIcon(status: status), // Custom icon for CareScreen
              const SizedBox(width: 8),
              Text(
                status,
                style: const TextStyle(
                  fontFamily: 'Inter-SemiBold',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.02, // -2% letter spacing
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter-SemiBold',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Inter-Medium',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
