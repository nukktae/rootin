import 'package:flutter/material.dart';
import 'status_banner.dart';
import 'overview_section.dart';
import 'weekly_trends_chart.dart';
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
      final plantId = widget.plantDetail['plantId'] as int;
      
      if (token != null) {
        final plants = await _plantService.getPlants();
        final currentPlant = plants.firstWhere((p) => p.plantId == plantId);
        final currentPlantNickname = currentPlant.nickname;
        
        final allData = await _plantService.fetchPlantHistory(token);
        
        final plantData = allData.where((item) => 
          item['plant_name'] == currentPlantNickname && 
          item['event_values'] != null &&
          item['event_values'].isNotEmpty
        ).toList();
        
        if (_mounted) {
          setState(() {
            historicalData = plantData;
          });
        }
      }
    } catch (e) {
      print('Error fetching historical data: $e');
    }
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
          child: historicalData.isNotEmpty
            ? WeeklyTrendsChart(historicalData: historicalData)
            : currentMoisture != null
              ? Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'No historical data available yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
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