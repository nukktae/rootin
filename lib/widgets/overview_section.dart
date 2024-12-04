import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OverviewSection extends StatelessWidget {
  final double soilMoisture;
  final List<Map<String, dynamic>> moistureHistory;
  final String plantId;

  const OverviewSection({
    super.key,
    required this.soilMoisture,
    required this.moistureHistory,
    required this.plantId,
  });

  int calculateDaysUntilWatering() {
    if (moistureHistory.isEmpty) return 7; // Default fallback
    
    // Get the most recent readings
    final recentReadings = moistureHistory
        .where((data) => data['plant_id'].toString() == plantId)
        .take(24) // Last 24 readings
        .map((data) => data['event_values'][0] as double)
        .toList();

    if (recentReadings.isEmpty) return 7;

    // Calculate moisture loss rate per hour
    final moistureLossRate = _calculateMoistureLossRate(recentReadings);
    
    // Get thresholds from the data - with null safety
    final minHumidity = moistureHistory.first['humidity_min'] as num? ?? 30.0;
    final currentMoisture = recentReadings.first;
    
    // Calculate hours until minimum threshold is reached
    final moistureUntilMin = currentMoisture - minHumidity;
    final hoursUntilWatering = moistureUntilMin / moistureLossRate;
    
    // Convert to days and round up, ensure positive value
    return (hoursUntilWatering / 24).ceil().clamp(0, 7);
  }

  double _calculateMoistureLossRate(List<double> readings) {
    if (readings.length < 2) return 0.5; // Default rate if not enough data
    
    // Calculate average loss per hour
    final totalLoss = readings.first - readings.last;
    final hours = readings.length;
    
    // Ensure we don't return zero or negative rate
    final rate = (totalLoss / hours).abs();
    return rate < 0.1 ? 0.1 : rate; // Minimum rate of 0.1% per hour
  }

  String getMoistureStatus(double moisture) {
    if (moisture < 30) {
      return 'Underwater';
    } else if (moisture > 70) {
      return 'Overwatered';
    } else {
      return 'Ideal';
    }
  }

  Color getMoistureColor(String status) {
    switch (status) {
      case 'Underwater':
        return const Color(0xFFD4B500); // Yellow
      case 'Ideal':
        return const Color(0xFF73C2FB); // Light Blue
      case 'Overwatered':
        return const Color(0xFF24494E); // Dark Blue
      default:
        return Colors.grey;
    }
  }

  Widget _buildTooltipContent(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Upcoming Watering Information',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        'The upcoming watering section shows how many days until the next scheduled watering for optimal plant care.',
        style: TextStyle(fontSize: 14, color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final moistureStatus = getMoistureStatus(soilMoisture);
    final moistureColor = getMoistureColor(moistureStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overview Title and Subtitle (outside of white container)
        const Text(
          'Overview',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.22,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Soil moisture updates every minute for real-time care!',
          style: TextStyle(
            color: Color(0xFF757575),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.24,
          ),
        ),
        const SizedBox(height: 24),
        // Moisture and Watering Info Row in white boxes
        Row(
          children: [
            // Current Soil Moisture Box
            Expanded(
              child: Container(
                height: 148,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current\nSoil Moisture',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${soilMoisture.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: moistureColor,
                        fontSize: 28,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      moistureStatus,
                      style: TextStyle(
                        color: moistureColor,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Upcoming Watering Box
            Expanded(
              child: Container(
                height: 148,
                padding: const EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Upcoming\nWatering',
                            style: TextStyle(
                              color: Color(0xFF757575),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: _buildTooltipContent,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/info_icon.svg',
                            width: 16,
                            height: 16,
                            color: const Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      calculateDaysUntilWatering() == 0 ? 'Today' : calculateDaysUntilWatering().toString(),
                      style: const TextStyle(
                        color: Color(0xFFFFB749),
                        fontSize: 28,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    if (calculateDaysUntilWatering() != 0)
                      const Text(
                        'days later',
                        style: TextStyle(
                          color: Color(0xFFFFB749),
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
