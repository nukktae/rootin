import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyTrendsChart extends StatelessWidget {
  final List<Map<String, dynamic>> historicalData;
  
  const WeeklyTrendsChart({super.key, required this.historicalData});

  @override
  Widget build(BuildContext context) {
    print('Historical Data received: ${historicalData.length}'); // Debug print

    if (historicalData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(child: Text('No historical data available')),
      );
    }

    // Sort data by timestamp in descending order
    final sortedData = List<Map<String, dynamic>>.from(historicalData)
      ..sort((a, b) {
        try {
          final timestampA = DateTime.parse(a['timestamp'].toString()).millisecondsSinceEpoch;
          final timestampB = DateTime.parse(b['timestamp'].toString()).millisecondsSinceEpoch;
          return timestampB.compareTo(timestampA);
        } catch (e) {
          return 0;
        }
      });

    print('Sorted Data length: ${sortedData.length}'); // Debug print

    // Get the most recent 7 readings
    final recentReadings = sortedData.take(7).map((reading) {
      try {
        final values = reading['event_values'] as List;
        return values.first.toDouble();
      } catch (e) {
        return 0.0;
      }
    }).toList();

    print('Recent readings: $recentReadings'); // Debug print

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
                  'Moisture Level',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
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
                        if (value.toInt() >= moistureData.length) return const Text('');
                        final date = DateTime.now().subtract(
                          Duration(days: (moistureData.length - 1 - value.toInt())),
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
 