import 'package:flutter/material.dart';
import '../models/plant.dart';

class PlantAITitleBar extends StatelessWidget {
  final Plant? plant;

  const PlantAITitleBar({
    super.key,
    this.plant,
  });

  @override
  Widget build(BuildContext context) {
    String title = plant?.nickname != null 
        ? "${plant!.nickname}'s Doctor"
        : 'Plant AI';

    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
