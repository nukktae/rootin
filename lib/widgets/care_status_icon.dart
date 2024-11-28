import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CareStatusIcon extends StatelessWidget {
  final String status;

  const CareStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String iconPath;
    Color backgroundColor;

    // Determine icon and background color based on status
    switch (status.toUpperCase()) {
      case "IDEAL":
        iconPath = 'assets/icons/status_ideal.svg';
        backgroundColor = const Color(0xFF73C2FB); // Light blue for Ideal
        break;
      case "UNDERWATER":
        iconPath = 'assets/icons/status_underwater.svg';
        backgroundColor = const Color(0xFFD3B400); // Yellow for Underwater
        break;
      case "MEASURING":
        iconPath = 'assets/icons/measuring_logo.svg';
        backgroundColor = const Color(0xFF6F6F6F); // Gray for Measuring
        break;
      default:
        iconPath = 'assets/icons/status_ideal.svg';
        backgroundColor = const Color(0xFF73C2FB); // Default to Ideal
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Pill shape padding
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20), // Fully rounded pill shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon Container
          Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white, // Icon background color
              shape: BoxShape.circle, // Circular background for icon
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.75), // Centering the SVG icon
              child: SvgPicture.asset(
                iconPath,
                width: 14, // Adjusted size to fit within the circle
                height: 14,
              ),
            ),
          ),
          const SizedBox(width: 4), // Space between icon and text
          // Status Text
          Text(
            status,
            style: const TextStyle(
              fontSize: 14, // Text size as specified
              fontWeight: FontWeight.w600, // Semi-bold weight
              fontFamily: 'Inter-SemiBold', // Custom font
              color: Colors.white, // White text color
              height: 1.5, // Line height adjustment
            ),
          ),
        ],
      ),
    );
  }
}
