import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OverviewSection extends StatelessWidget {
  final double soilMoisture; // From backend API
  final int wateringIntervalDays; // Each plant has different interval days

  const OverviewSection({
    super.key,
    required this.soilMoisture,
    required this.wateringIntervalDays,
  });

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
                      wateringIntervalDays == 0 ? 'Today' : wateringIntervalDays.toString(),
                      style: const TextStyle(
                        color: Color(0xFFFFB749),
                        fontSize: 28,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    if (wateringIntervalDays != 0)
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
