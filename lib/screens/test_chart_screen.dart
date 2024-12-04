import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/plant_service.dart';

class TestChartScreen extends StatefulWidget {
  const TestChartScreen({super.key});

  @override
  State<TestChartScreen> createState() => _TestChartScreenState();
}

class _TestChartScreenState extends State<TestChartScreen> {
  Map<int, List<double>> plantReadings = {53: [], 54: []};
  final PlantService _plantService = PlantService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final token = dotenv.env['FCM_TOKEN'];
      if (token == null) return;

      final response = await _plantService.fetchPlantHistory(token);

      // Load data for both plants
      for (int plantId in [53, 54]) {
        final plantData = response.where((item) => 
          item['plant_id'] == plantId
        ).toList();

        if (plantData.isNotEmpty) {
          // Get readings with more variation
          final List<MapEntry<DateTime, double>> readings = [];
          
          for (var item in plantData) {
            try {
              final timestamp = (int.parse(item['timestamp'].toString()) / 1000).floor();
              final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
              final value = double.parse(item['event_values'].first.toString());
              
              readings.add(MapEntry(dateTime, value));
            } catch (e) {
              print('Error processing reading: $e');
              continue;
            }
          }

          // Sort by date in ascending order (oldest first)
          readings.sort((a, b) => a.key.compareTo(b.key));

          // Take one reading per day for the last 7 days
          final Map<String, double> dailyReadings = {};
          for (var reading in readings) {
            final dateKey = '${reading.key.year}-${reading.key.month}-${reading.key.day}';
            if (!dailyReadings.containsKey(dateKey)) {
              dailyReadings[dateKey] = reading.value;
            }
          }

          // Get the last 7 days of readings in correct order
          final sortedDays = dailyReadings.keys.toList()..sort();
          final List<double> finalReadings = sortedDays
              .take(7)
              .map((key) => dailyReadings[key]!)
              .toList();

          print('\nFinal 7 readings for Plant $plantId:');
          for (var i = 0; i < finalReadings.length; i++) {
            final date = DateTime.now().subtract(Duration(days: (finalReadings.length - 1 - i)));
            print('${date.month}/${date.day}: ${finalReadings[i]}%');
          }

          if (finalReadings.isNotEmpty) {
            setState(() {
              plantReadings[plantId] = finalReadings;
            });
          }
        }
      }
    } catch (e, stackTrace) {
      print('Error loading data: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Widget _buildChart(int plantId, List<double> readings) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: Column(
        children: [
          Text('Plant $plantId Moisture Readings', 
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                minX: 0,
                maxX: readings.length.toDouble() - 1,
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      readings.length,
                      (index) => FlSpot(index.toDouble(), readings[index]),
                    ),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 2,
                    dotData: const FlDotData(show: true),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        final date = DateTime.now().subtract(
                          Duration(days: (readings.length - 1 - index)),
                        );
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${date.month}/${date.day}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}%');
                      },
                    ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Moisture Trends'),
      ),
      body: plantReadings[53]!.isEmpty && plantReadings[54]!.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                if (plantReadings[53]!.isNotEmpty)
                  _buildChart(53, plantReadings[53]!),
                if (plantReadings[54]!.isNotEmpty)
                  _buildChart(54, plantReadings[54]!),
              ],
            ),
    );
  }
} 