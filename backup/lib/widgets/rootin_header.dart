import 'package:flutter/material.dart';

class RootinHeader extends StatelessWidget {
  const RootinHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            width: 32,
            height: 24,
            child: Image.asset(
              'assets/images/rootin_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Text(
            'rootin',
            style: TextStyle(
              color: Color(0xFF8E8E8E),
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
} 