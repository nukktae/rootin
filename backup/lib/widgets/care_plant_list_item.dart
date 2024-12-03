import 'package:flutter/material.dart';
import '../models/plant.dart';

class CarePlantListItem extends StatelessWidget {
  final Plant plant;
  final String message;
  final Color messageColor;

  const CarePlantListItem({
    super.key,
    required this.plant,
    required this.message,
    required this.messageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0), // Reduced horizontal padding for wider card
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        padding: const EdgeInsets.all(16.0), // Padding inside the card
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Larger image with rounded rectangle
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // Rounded corners for image
              child: Image.network(
                plant.imageUrl,
                width: 70, // Image width
                height: 70, // Image height
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16), // Space between image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant name
                  Text(
                    plant.plantTypeName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Location text
                  Text(
                    "In ${plant.category ?? 'Unknown Location'}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Status message
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 12,
                      color: messageColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
