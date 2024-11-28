import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../services/plant_service.dart';
import '../widgets/watering_header.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/underwater_plants_card.dart';
import '../widgets/in_progress_plants_card.dart';
import '../widgets/done_plants_card.dart';
import '../screens/notification_settings_screen.dart';
import '../widgets/ai_chat_fab.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});

  @override
  CareScreenState createState() => CareScreenState();
}

class CareScreenState extends State<CareScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Plant>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _plantsFuture = PlantService().getPlants();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: WateringHeader(
          onSettingsPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationSettingsScreen(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          CustomTabBar(controller: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPlantStatusList("Today"),
                _buildPlantStatusList("Upcoming"),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: const AIChatFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPlantStatusList(String filter) {
    return FutureBuilder<List<Plant>>(
      future: _plantsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No plants available'));
        }

        final plants = snapshot.data!;

        // Get underwater plants (WATER_NEEDED status)
        final underwaterPlants = plants
            .where((plant) => plant.status == 'WATER_NEEDED')
            .map((plant) => {
                  'plantId': plant.plantId,
                  'name': plant.plantTypeName,
                  'location': 'In ${plant.category}',
                  'imageUrl': plant.imageUrl,
                })
            .toList();

        // Get in progress plants (MEASURING status)
        final inProgressPlants = plants
            .where((plant) => plant.status == 'MEASURING')
            .map((plant) => {
                  'plantId': plant.plantId,
                  'name': plant.plantTypeName,
                  'location': 'In ${plant.category}',
                  'imageUrl': plant.imageUrl,
                })
            .toList();

        // Get ideal (done) plants
        final donePlants = plants
            .where((plant) => plant.status == 'IDEAL')
            .map((plant) => {
                  'plantId': plant.plantId,
                  'name': plant.plantTypeName,
                  'location': 'In ${plant.category}',
                  'imageUrl': plant.imageUrl,
                })
            .toList();

        if (filter == "Today") {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            children: [
              const SizedBox(height: 32),
              const SizedBox(
                width: 353,
                child: Text(
                  'To-Do',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                    letterSpacing: -0.22,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              if (underwaterPlants.isNotEmpty)
                UnderwaterPlantsCard(
                  count: underwaterPlants.length,
                  plants: underwaterPlants,
                ),
              
              if (underwaterPlants.isNotEmpty && inProgressPlants.isNotEmpty)
                const SizedBox(height: 32),
                
              if (inProgressPlants.isNotEmpty)
                InProgressPlantsCard(
                  count: inProgressPlants.length,
                  plants: inProgressPlants,
                ),

              if ((underwaterPlants.isNotEmpty || inProgressPlants.isNotEmpty) && donePlants.isNotEmpty)
                const SizedBox(height: 32),

              if (donePlants.isNotEmpty)
                DonePlantsCard(
                  count: donePlants.length,
                  plants: donePlants,
                ),
            ],
          );
        } else {
          // Upcoming tab content
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            children: [
              const SizedBox(height: 32),
              const SizedBox(
                width: 353,
                child: Text(
                  'To-Do',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0.06,
                    letterSpacing: -0.22,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              if (underwaterPlants.isNotEmpty)
                UnderwaterPlantsCard(
                  count: underwaterPlants.length,
                  plants: underwaterPlants,
                )
              else
                const Center(child: Text("No tasks to display")),
            ],
          );
        }
      },
    );
  }
}
