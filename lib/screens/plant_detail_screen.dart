import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../widgets/real_time_soil_moisture_screen.dart';
import '../widgets/care_tips_section.dart';
import '../services/plant_service.dart';
import '../models/plant.dart';
import '../l10n/app_localizations.dart';

class PlantDetailScreen extends StatefulWidget {
  final String plantTypeId;

  const PlantDetailScreen({
    super.key, 
    required this.plantTypeId,
  });

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> with SingleTickerProviderStateMixin {
  bool showCareTips = true;
  Plant? cachedPlant;
  Future<List<Plant>>? _plantsFuture;
  late PageController _pageController;
  int _currentIndex = 0;
  List<Map<String, dynamic>> historicalData = [];
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _initShineAnimation();
    _pageController = PageController(
      viewportFraction: 0.95,
      initialPage: 0,
    )..addListener(_handlePageChange);
    _plantsFuture = PlantService().getPlants().then((plants) {
      int initialIndex = plants.indexWhere((p) => p.plantTypeId == widget.plantTypeId);
      if (initialIndex != -1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _pageController.jumpToPage(initialIndex);
          setState(() {
            _currentIndex = initialIndex;
          });
        });
      }
      return plants;
    });
    loadPlantData();
  }

  void _initShineAnimation() {
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _shineAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shineController,
      curve: Curves.easeInOut,
    ));

    // Start initial shine animation
    Future.delayed(const Duration(milliseconds: 100), () {
      _shineController.forward();
    });
  }

  void _handlePageChange() {
    if (_pageController.page?.round() != _currentIndex) {
      setState(() {
        _currentIndex = _pageController.page!.round();
      });
      // Trigger shine animation for the new plant
      _shineController.reset();
      _shineController.forward();
    }
  }

  @override
  void dispose() {
    _shineController.dispose();
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    super.dispose();
  }

  Future<void> loadPlantData() async {
    try {
      final fcmToken = dotenv.env['FCM_TOKEN'];
      if (fcmToken == null) {
        print('FCM Token not found');
        return;
      }
      
      final response = await PlantService().fetchPlantHistory(fcmToken);
      
      // Get readings with more variation
      final List<MapEntry<DateTime, double>> readings = [];
      
      for (var item in response) {
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

      // Take one reading per day
      final Map<String, double> dailyReadings = {};
      for (var reading in readings) {
        final dateKey = '${reading.key.year}-${reading.key.month}-${reading.key.day}';
        if (!dailyReadings.containsKey(dateKey)) {
          dailyReadings[dateKey] = reading.value;
        }
      }

      // Get the readings in correct order
      final sortedDays = dailyReadings.keys.toList()..sort();
      final List<double> finalReadings = sortedDays
          .take(7)
          .map((key) => dailyReadings[key]!)
          .toList();

      print('\nFinal readings:');
      for (var i = 0; i < finalReadings.length; i++) {
        final date = DateTime.now().subtract(Duration(days: (finalReadings.length - 1 - i)));
        print('${date.month}/${date.day}: ${finalReadings[i]}%');
      }

      setState(() {
        historicalData = finalReadings.map((value) => {
          'value': value,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }).toList();
      });
    } catch (e) {
      print('Error loading plant history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return FutureBuilder<List<Plant>>(
      future: _plantsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('No plants found')),
          );
        }

        final plants = snapshot.data!;
        
        return Scaffold(
          backgroundColor: const Color(0xFFF4F4F4),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 55),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildIconButton('close.svg', () => Navigator.pop(context)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                SizedBox(
                  height: 350,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemCount: plants.length,
                        pageSnapping: true,
                        itemBuilder: (context, index) {
                          final plant = plants[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Text(
                                  plant.nickname ?? plant.plantTypeName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 393,
                                  child: Text(
                                    plant.plantTypeName,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF6F6F6F),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                      letterSpacing: -0.16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SizedBox(
                                  width: 393,
                                  child: Text(
                                    'In ${plant.category.split('/')[0]}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF6F6F6F),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.2,
                                      letterSpacing: -0.16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildShineEffect(
                                  Container(
                                    width: 250,
                                    height: 250,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(plant.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(45),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      if (_currentIndex > 0)
                        Positioned(
                          left: -120,
                          top: 140,
                          child: GestureDetector(
                            onTap: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(plants[_currentIndex - 1].imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      if (_currentIndex < plants.length - 1)
                        Positioned(
                          right: -120,
                          top: 140,
                          child: GestureDetector(
                            onTap: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(plants[_currentIndex + 1].imageUrl),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showCareTips = true;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: ShapeDecoration(
                            color: showCareTips ? Colors.black : const Color(0xFFEEEEEE),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              appLocalizations.careTips,
                              style: TextStyle(
                                color: showCareTips ? Colors.white : Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showCareTips = false;
                          });
                        },
                        child: Container(
                          width: 200,
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: ShapeDecoration(
                            color: showCareTips ? const Color(0xFFEEEEEE) : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              appLocalizations.realTimeSoilMoisture,
                              style: TextStyle(
                                color: showCareTips ? Colors.black : Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                showCareTips
                    ? CareTipsSection(
                        plant: plants[_currentIndex],
                        careTips: [
                          plants[_currentIndex].infoDifficulty,
                          plants[_currentIndex].infoWatering,
                          plants[_currentIndex].infoLight,
                          plants[_currentIndex].infoSoilType,
                          plants[_currentIndex].infoRepotting,
                          plants[_currentIndex].infoToxicity,
                        ],
                      )
                    : RealTimeSoilMoistureScreen(
                        plantDetail: {
                          'plantId': plants[_currentIndex].plantId,
                          'current_moisture': plants[_currentIndex].currentMoisture,
                          'moisture_range': plants[_currentIndex].moistureRange,
                          'status': plants[_currentIndex].status,
                          'nickname': plants[_currentIndex].nickname,
                        },
                        status: plants[_currentIndex].status,
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton(String assetName, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffE7E7E7),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/$assetName',
          width: 24,
          height: 24,
          color: Colors.black,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildShineEffect(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(45),
      child: Stack(
        children: [
          child,
          AnimatedBuilder(
            animation: _shineAnimation,
            builder: (context, child) {
              return Positioned.fill(
                child: Transform.rotate(
                  angle: -0.8,
                  child: Transform.translate(
                    offset: Offset(
                      _shineAnimation.value * 300,
                      0,
                    ),
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.6),
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0),
                          ],
                          stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}