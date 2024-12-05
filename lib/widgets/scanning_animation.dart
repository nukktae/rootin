import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ScanningAnimation extends StatelessWidget {
  final bool isPlantDetected;
  final double size;

  const ScanningAnimation({
    super.key,
    required this.isPlantDetected,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Base circle
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isPlantDetected ? Colors.green : Colors.white,
              width: 2,
            ),
          ),
        ),
        
        // Scanning animation
        SizedBox(
          width: size,
          height: size,
          child: Lottie.asset(
            'assets/animations/scanning.json',
            fit: BoxFit.contain,
            animate: !isPlantDetected, // Stop animation when plant is detected
          ),
        ),
        
        // Detection indicator
        if (isPlantDetected)
          Container(
            width: size * 1.02,
            height: size * 1.02,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.green,
                width: 3,
              ),
            ),
          ),
          
        // Success checkmark
        if (isPlantDetected)
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: size * 0.2,
          ),
      ],
    );
  }
} 