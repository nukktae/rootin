// File: add_plant_item.dart

// Note: Replace SvgPicture.asset with Image.network(imagePath) when fetching images from backend.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Define a reusable widget for the plant item.
class PlantItem extends StatelessWidget {
  final String plantName;
  final String plantSubName;
  final String imagePath;

  const PlantItem({
    super.key,
    required this.plantName,
    required this.plantSubName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: SvgPicture.asset(
              'assets/plant_image.svg',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plantName,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
              ),
              Text(
                plantSubName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}