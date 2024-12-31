import 'package:flutter/material.dart';
import '../widgets/status_icon.dart';
import '../screens/plant_detail_screen.dart';
import '../models/plant.dart';
import '../l10n/app_localizations.dart';

class PlantGridView extends StatelessWidget {
  final List<Plant> plants;
  final String emptyMessage;
  final TextStyle? emptyMessageStyle;

  const PlantGridView({
    super.key,
    required this.plants,
    required this.emptyMessage,
    this.emptyMessageStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
        childAspectRatio: 0.75,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        
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
                  child: AspectRatio(
                    aspectRatio: 1,
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
                ),
                const SizedBox(height: 8),
                Text(
                  plant.nickname.isNotEmpty ? plant.nickname : plant.plantTypeName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  plant.plantTypeName,
                  style: const TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppLocalizations.of(context).in_} ${plant.category.split('/').last}',
                  style: const TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.0,
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