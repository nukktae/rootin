import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter-SemiBold',
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                subtitle!,
                style: const TextStyle(
                  fontFamily: 'Inter-Medium',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xFF06C167), // Green color
                ),
              ),
            ),
        ],
      ),
    );
  }
}
