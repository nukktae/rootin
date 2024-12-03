import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter-Medium',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              iconPath,
              width: 16,
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
