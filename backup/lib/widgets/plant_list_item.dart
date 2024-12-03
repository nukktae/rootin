import 'package:flutter/material.dart';

class PlantListItem extends StatelessWidget {
  final String name;
  final String scientificName;
  final String imageUrl;
  final VoidCallback onTap;

  const PlantListItem({
    super.key,
    required this.name,
    required this.scientificName,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 64,
                  height: 64,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scientificName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 