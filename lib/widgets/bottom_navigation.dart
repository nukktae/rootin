import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 103,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: 1.60, color: Color(0xFFEEEEEE)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, 'Home', 'assets/icons/home.svg', const Color(0xFF05C0C7)),
          _buildNavItem(1, 'Watering', 'assets/icons/watering.svg', const Color(0xFFAFAFAF)),
          _buildNavItem(2, 'Plant AI', 'assets/icons/plant_ai.svg', const Color(0xFFAFAFAF)),
          _buildNavItem(3, 'Profile', 'assets/icons/profile.svg', const Color(0xFFAFAFAF)),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath, Color color) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 23,
          right: 24,
          bottom: 23,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              color: isSelected ? const Color(0xFF05C0C7) : const Color(0xFFAFAFAF),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? const Color(0xFF05C0C7) : const Color(0xFFAFAFAF),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0,
                letterSpacing: -0.28,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 