import 'package:flutter/material.dart';

class TodaysCareTitleRow extends StatelessWidget {
  const TodaysCareTitleRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Today's Watering",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Inter', // Set font family to Inter
            fontWeight: FontWeight.w600, // SemiBold weight
            letterSpacing: -0.1, // Adjust letter spacing
          ),
        ),
      ],
    );
  }
}
