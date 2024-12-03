import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String plantName;
  final String location;
  final String imageUrl;
  final double waterLevel;
  final double overwaterThreshold;
  final String? status;
  final int? currentMoisture;

  const PlantCard({
    super.key,
    required this.plantName,
    required this.location,
    required this.imageUrl,
    required this.waterLevel,
    required this.overwaterThreshold,
    this.status,
    this.currentMoisture,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        color: Colors.white, // Ensure a flat background color with no shadow
        child: Stack(
          children: [
            // Plant Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                height: 162,
                width: 162,
                fit: BoxFit.cover,
              ),
            ),
            // Overwatered Icon based on dynamic threshold
            if (waterLevel > overwaterThreshold)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
              ),
            // Plant Name, Location, and Additional Details
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant Name with larger font and custom font family
                  Text(
                    plantName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600, // SemiBold weight
                      color: Colors.black,
                    ),
                  ),
                  // Location with smaller font and custom font family
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500, // Medium weight
                      color: Colors.grey,
                    ),
                  ),
                  // Status and Moisture Level (optional)
                  if (status != null || currentMoisture != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          if (status != null)
                            Text(
                              status!,
                              style: TextStyle(
                                fontSize: 12,
                                color: status == "IDEAL" ? Colors.green : Colors.red,
                              ),
                            ),
                          if (currentMoisture != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Moisture: ${currentMoisture!}%',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                        ],
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
