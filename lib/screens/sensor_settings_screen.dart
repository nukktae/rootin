import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/plant_service.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';

class SensorSettingsScreen extends StatefulWidget {
  const SensorSettingsScreen({super.key});

  @override
  State<SensorSettingsScreen> createState() => _SensorSettingsScreenState();
}

class _SensorSettingsScreenState extends State<SensorSettingsScreen> {
  final PlantService _plantService = PlantService();
  List<Plant> plants = [];
  bool isLoading = true;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    try {
      final loadedPlants = await _plantService.getPlants();
      if (mounted) {
        setState(() {
          plants = loadedPlants.where((plant) => plant.status != 'NO_SENSOR').toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String _getRandomBatteryLevel() {
    return '${_random.nextInt(100)}%';
  }

  String _generateSensorId() {
    String numbers = List.generate(5, (_) => _random.nextInt(10)).join();
    return 'IB$numbers';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const ShapeDecoration(
            color: Color(0xFFEEEEEE),
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const SizedBox.shrink(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 24, bottom: 24),
                  child: Text(
                    'Sensor Settings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.28,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: plants.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF5F5F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: _buildSensorCard(plants[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSensorCard(Plant plant) {
    final batteryLevel = _getRandomBatteryLevel();
    final sensorId = _generateSensorId();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(plant.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.nickname.isNotEmpty ? plant.nickname : plant.plantTypeName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.40,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(right: 8),
                          child: SvgPicture.asset(
                            'assets/icons/sensor.svg',
                            width: 16,
                            height: 16,
                          ),
                        ),
                        Text(
                          sensorId,
                          style: const TextStyle(
                            color: Color(0xFF6F6F6F),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Color(0xFF404040)),
              onPressed: () {
                // Handle settings
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.battery_full, size: 16, color: Color(0xFF404040)),
              const SizedBox(width: 10),
              Text(
                batteryLevel,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.28,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.wifi, size: 16, color: Color(0xFF404040)),
              const SizedBox(width: 10),
              const Text(
                'Said77',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.28,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.bluetooth, size: 16, color: Color(0xFF404040)),
              const SizedBox(width: 10),
              const Text(
                'Nathan\'s iPhone',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.28,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 