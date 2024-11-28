import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyTrendsChart extends StatelessWidget {
  final List<Map<String, dynamic>> historicalData;
  
  const WeeklyTrendsChart({super.key, required this.historicalData});

  @override
  Widget build(BuildContext context) {
    // Sort data by timestamp in descending order
    final sortedData = List<Map<String, dynamic>>.from(historicalData)
      ..sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

    // Get the most recent 7 readings
    final recentReadings = sortedData.take(7).map((reading) {
      return reading['event_values'][0].toDouble();
    }).toList();

    // Reverse to show oldest to newest
    final moistureData = recentReadings.reversed.toList();

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Legend
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF17C6ED),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Soil Moisture',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E7EB),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ideal Range (30-70%)',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                minX: 0,
                maxX: 6,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // Ideal range area
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 70),
                      FlSpot(6, 70),
                    ],
                    isCurved: false,
                    color: Colors.transparent,
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFF3F4F6),
                      cutOffY: 30,
                      applyCutOffY: true,
                    ),
                  ),
                  // Moisture line
                  LineChartBarData(
                    spots: List.generate(moistureData.length, (index) {
                      return FlSpot(index.toDouble(), moistureData[index]);
                    }),
                    isCurved: true,
                    color: const Color(0xFF17C6ED),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF17C6ED).withOpacity(0.1),
                    ),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date = DateTime.now().subtract(
                          Duration(days: (6 - value).toInt()),
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${date.month}/${date.day}',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 