import 'package:flutter/material.dart';
import '../widgets/status_icon.dart';
import 'dart:developer';
import '../screens/plant_detail_screen.dart';
import '../models/plant.dart';

class PlantGridView extends StatelessWidget {
  final List<Plant> plants;
  final String emptyMessage;

  const PlantGridView({
    super.key,
    required this.plants,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(
            color: Color(0xFF6F6F6F),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        log('Plant data for grid item: ${plant.toJson()}');
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantDetailScreen(
                  plantTypeId: plant.plantTypeId,
                ),
              ),
            );
          },
          child: Container(
            constraints: const BoxConstraints(maxHeight: 280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEEEEEE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: plant.imageUrl != null
                              ? Image.network(
                                  plant.imageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    log('Image error for ${plant.nickname}: $error');
                                    return const Icon(
                                      Icons.image_not_supported,
                                      color: Color(0xFF8E8E8E),
                                    );
                                  },
                                )
                              : const SizedBox.shrink(),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: StatusIcon(status: plant.status ?? 'NO_SENSOR'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plant.nickname.isNotEmpty ? plant.nickname : plant.plantTypeName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  plant.plantTypeName,
                  style: const TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'In ${plant.category.split('/').last}',
                  style: const TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}