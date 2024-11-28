import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/plant.dart';

class PlantAITitleBar extends StatelessWidget {
  final Plant? plant;

  const PlantAITitleBar({
    super.key,
    this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back Arrow
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFE7E7E7),
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  'assets/icons/arrow.svg',
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ),
          // Centered Title
          Text(
            plant != null ? plant!.nickname : 'AI Chatbot',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
