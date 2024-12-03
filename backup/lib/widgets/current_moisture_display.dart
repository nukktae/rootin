import 'package:flutter/material.dart';

class CurrentMoistureDisplay extends StatelessWidget {
  final double currentMoisture;
  final double idealMin;
  final double idealMax;

  const CurrentMoistureDisplay({
    super.key,
    required this.currentMoisture,
    required this.idealMin,
    required this.idealMax,
  });

  @override
  Widget build(BuildContext context) {
    final isWithinIdealRange = currentMoisture >= idealMin && currentMoisture <= idealMax;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWithinIdealRange ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Current Soil Moisture',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${currentMoisture.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isWithinIdealRange ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ideal Range: ${idealMin.toInt()}% - ${idealMax.toInt()}%',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
