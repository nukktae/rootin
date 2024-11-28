import 'package:flutter/material.dart';

class WateringHeader extends StatelessWidget {
  final VoidCallback onSettingsPressed;

  const WateringHeader({
    super.key,
    required this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Watering',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.28,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: onSettingsPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
