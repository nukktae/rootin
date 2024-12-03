import 'package:flutter/material.dart';

class CarePlantCard extends StatelessWidget {
  final String plantName;
  final String location;
  final String imageUrl;
  final String lastUpdated;

  const CarePlantCard({
    super.key,
    required this.plantName,
    required this.location,
    required this.imageUrl,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Plant Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12), // Spacing between image and details
          
          // Plant Details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plantName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Last Updated Text
          Text(
            lastUpdated,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
            ),
          ),

          // Arrow Icon
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}