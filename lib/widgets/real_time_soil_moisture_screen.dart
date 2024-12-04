import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'status_banner.dart';
import 'overview_section.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import '../services/plant_service.dart';

class RealTimeSoilMoistureScreen extends StatefulWidget {
  final Map<String, dynamic> plantDetail;
  final String status;

  const RealTimeSoilMoistureScreen({
    super.key,
    required this.plantDetail,
    required this.status,
  });

  @override
  State<RealTimeSoilMoistureScreen> createState() => _RealTimeSoilMoistureScreenState();
}

class _RealTimeSoilMoistureScreenState extends State<RealTimeSoilMoistureScreen> {
  List<Map<String, dynamic>> historicalData = [];
  Timer? _timer;
  bool _mounted = true;
  final PlantService _plantService = PlantService();

  @override
  void initState() {
    super.initState();
    _fetchHistoricalData();
    _startTimer();
  }

  @override
  void dispose() {
    _mounted = false;
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_mounted) {
        _fetchHistoricalData();
      }
    });
  }

  Future<void> _fetchHistoricalData() async {
    try {
      final token = dotenv.env['FCM_TOKEN'];
      final plantId = widget.plantDetail['plantId'];
      
      if (token != null && plantId != null) {
        final response = await _plantService.fetchPlantHistory(token);
        
        final plantData = response.where((item) => 
          item['plant_id'].toString() == plantId.toString()
        ).toList();

        if (plantData.isNotEmpty) {
          final List<MapEntry<DateTime, double>> readings = [];
          
          for (var item in plantData) {
            try {
              final timestamp = (int.parse(item['timestamp'].toString()) / 1000).floor();
              final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
              final value = double.parse(item['event_values'].first.toString());
              readings.add(MapEntry(dateTime, value));
            } catch (e) {
              continue;
            }
          }

          readings.sort((a, b) => a.key.compareTo(b.key));

          final Map<String, double> dailyReadings = {};
          for (var reading in readings) {
            final dateKey = '${reading.key.year}-${reading.key.month}-${reading.key.day}';
            dailyReadings[dateKey] = reading.value;
          }

          final sortedDays = dailyReadings.keys.toList()..sort();
          final List<double> finalReadings = sortedDays
              .take(7)
              .map((key) => dailyReadings[key]!)
              .toList();

          if (_mounted && finalReadings.isNotEmpty) {
            setState(() {
              historicalData = finalReadings.map((value) => {
                'plant_id': plantId,
                'timestamp': DateTime.now().toIso8601String(),
                'event_values': [value],
                'current_moisture': value,
              }).toList();
            });
          }
        }
      }
    } catch (e) {
      if (_mounted) {
        setState(() {
          historicalData = [];
        });
      }
    }
  }

  Widget _buildWeeklyTrendsChart() {
    if (historicalData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(child: Text('No historical data available')),
      );
    }

    final sortedData = List<Map<String, dynamic>>.from(historicalData)
      ..sort((a, b) {
        try {
          final timestampA = DateTime.parse(a['timestamp'].toString());
          final timestampB = DateTime.parse(b['timestamp'].toString());
          return timestampB.compareTo(timestampA);
        } catch (e) {
          return 0;
        }
      });

    final recentReadings = sortedData.take(7).map((reading) {
      try {
        final value = reading['current_moisture'];
        if (value == null) return 0.0;
        return value.toDouble();
      } catch (e) {
        return 0.0;
      }
    }).toList();

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

  @override
  Widget build(BuildContext context) {
    final currentMoisture = widget.plantDetail['current_moisture'] as num?;
    final status = widget.status;

    void handleStatusTap() {
      final upperStatus = status.toUpperCase();
      if (upperStatus == "WATER_NEEDED") {
        Navigator.pushNamed(context, "/watering");
      } else if (upperStatus == "WATERLOGGED") {
        Navigator.pushNamed(context, "/instructions");
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: StatusBanner(
            status: status,
            onButtonPressed: handleStatusTap,
          ),
        ),
        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: currentMoisture != null 
            ? OverviewSection(
                soilMoisture: currentMoisture.toDouble(),
                wateringIntervalDays: 7,
              )
            : const Text("No moisture data available"),
        ),
        const SizedBox(height: 40),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Weekly trends',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: currentMoisture != null
            ? _buildWeeklyTrendsChart()
            : Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Text(
                    'Preparing data...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
        ),

        const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              'Soil moisture updates every minute for real-time care!',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}