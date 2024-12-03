import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../widgets/real_time_soil_moisture_screen.dart';
import '../widgets/care_tips_section.dart';
import '../services/plant_service.dart';
import '../models/plant.dart';
import '../screens/ai_chatbot_screen.dart';

class PlantDetailScreen extends StatefulWidget {
  final String plantTypeId;

  const PlantDetailScreen({
    super.key, 
    required this.plantTypeId,
  });

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  bool showCareTips = true;
  Plant? cachedPlant;
  Future<List<Plant>>? _plantsFuture;
  late PageController _pageController;
  int _currentIndex = 0;
  List<Map<String, dynamic>> historicalData = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.95,
      initialPage: 0,
    );
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

  @override
  void dispose() {
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
      
      final history = await PlantService().fetchPlantHistory(fcmToken);
      setState(() {
        historicalData = history;
      });
    } catch (e) {
      print('Error loading plant history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  plant.plantTypeName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff6F6F6F),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'In ${plant.category}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff6F6F6F),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: 225,
                                  height: 225,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(plant.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
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
                          left: 16,
                          top: 200,
                          child: IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffE7E7E7),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/icons/leftarrow.svg',
                                  width: 24,
                                  height: 24,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      if (_currentIndex < plants.length - 1)
                        Positioned(
                          right: 16,
                          top: 200,
                          child: IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xffE7E7E7),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/icons/rightarrow.svg',
                                  width: 24,
                                  height: 24,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

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
                              'Care tips',
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
                              'Real-time Soil Moisture',
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
          floatingActionButton: AIChatFAB(plant: plants[_currentIndex]),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
}

class AIChatFAB extends StatelessWidget {
  final Plant? plant;

  const AIChatFAB({
    super.key,
    this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AIChatbotScreen(plant: plant),
            ),
          );
        },
        backgroundColor: const Color(0xFF04ABB0),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x1909ABB0),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
              BoxShadow(
                color: Color(0x1609ABB0),
                blurRadius: 8,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: Color(0x0C09ABB0),
                blurRadius: 10,
                offset: Offset(0, 17),
              ),
              BoxShadow(
                color: Color(0x0209ABB0),
                blurRadius: 12,
                offset: Offset(0, 31),
              ),
              BoxShadow(
                color: Color(0x0009ABB0),
                blurRadius: 13,
                offset: Offset(0, 48),
              ),
            ],
          ),
          child: SvgPicture.asset(
            'assets/icons/plantai_nav.svg',
            width: 32,
            height: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}