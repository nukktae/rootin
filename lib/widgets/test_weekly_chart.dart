import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../services/plant_service.dart';

class TestWeeklyChart extends StatefulWidget {
  final int plantId;
  
  const TestWeeklyChart({super.key, required this.plantId});

  @override
  State<TestWeeklyChart> createState() => _TestWeeklyChartState();
}

class _TestWeeklyChartState extends State<TestWeeklyChart> {
  List<double> moistureReadings = [];
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

      final historyList = await _plantService.fetchPlantHistory(token);
      
      // Filter for current plant
      final plantData = historyList.where((item) => 
        item['plant_id'] == widget.plantId && 
        item['current_moisture'] != null
      ).toList();

      print('Raw plant data: $plantData'); // Debug print

      if (plantData.isNotEmpty) {
        // Get the current moisture reading
        final currentMoisture = plantData.first['current_moisture'] as double;
        
        // Create 7 days of mock data
        final List<double> mockReadings = List.generate(7, (index) {
          final variance = (index - 3) * 2.0;
          return (currentMoisture + variance).clamp(0.0, 100.0);
        });

        setState(() {
          moistureReadings = mockReadings;
        });
        
        print('Mock readings generated: $mockReadings'); // Debug print
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (moistureReadings.isEmpty) {
      return const Center(child: Text('Loading...'));
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
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
              spots: List.generate(
                moistureReadings.length,
                (index) => FlSpot(index.toDouble(), moistureReadings[index]),
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
                  final date = DateTime.now().subtract(
                    Duration(days: (6 - value).toInt()),
                  );
                  return Text('${date.month}/${date.day}');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
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
    );
  }
} 