import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class CareBanner extends StatelessWidget {
  final Function(int) setCurrentIndex;
  final int underwaterCount;

  const CareBanner({
    super.key,
    required this.setCurrentIndex,
    required this.underwaterCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setCurrentIndex(1),
      child: Container(
        width: double.infinity,
        height: 104,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: ShapeDecoration(
          color: const Color(0xFFEEEEEE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You have $underwaterCount ${underwaterCount == 1 ? 'plant' : 'plants'}\nwaiting to be watered',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Text(
                      'Check your watering',
                      style: TextStyle(
                        color: Color(0xFF6F6F6F),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF6F6F6F),
                      size: 12,
                    ),
                  ],
                ),
              ],
            ),
            Image.asset(
              'assets/images/carebannerlogo.png',
              width: 80,
              height: 80,
              errorBuilder: (context, error, stackTrace) {
                dev.log('PNG failed to load: $error');
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.red.withOpacity(0.1),
                  child: const Icon(
                    Icons.error,
                    size: 40,
                    color: Colors.red,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
