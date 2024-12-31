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
import '../l10n/app_localizations.dart';

class CareScreen extends StatefulWidget {
  final Function(int) setCurrentIndex;
  final int initialTabIndex;

  const CareScreen({
    super.key,
    required this.setCurrentIndex,
    this.initialTabIndex = 0,
  });

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Plant>> _plantsFuture;
  final PlantService _plantService = PlantService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _refreshPlants();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshPlants() async {
    setState(() {
      _plantsFuture = _plantService.getPlants();
    });
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
          CustomTabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text(
                  AppLocalizations.of(context).today,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.14,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  AppLocalizations.of(context).upcoming,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.14,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPlantStatusList(AppLocalizations.of(context).today),
                _buildPlantStatusList(AppLocalizations.of(context).upcoming),
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

        // Get all plants categorized
        final underwaterPlants = plants
            .where((plant) => 
                plant.status != 'NO_SENSOR' && 
                plant.status != 'UNKNOWN' &&
                plant.status != 'MEASURING' &&
                plant.currentMoisture < (plant.moistureRange['min'] ?? 0.0))
            .map((plant) => {
                  'plantId': plant.plantId,
                  'plantTypeId': plant.plantTypeId,
                  'name': plant.nickname.isNotEmpty ? plant.nickname : plant.plantTypeName,
                  'location': 'In ${plant.category}',
                  'imageUrl': plant.imageUrl,
                })
            .toList();

        final inProgressPlants = plants
            .where((plant) => 
                plant.status == 'MEASURING' || 
                plant.status == 'NO_SENSOR'
            )
            .map((plant) => {
                  'plantId': plant.plantId,
                  'plantTypeId': plant.plantTypeId,
                  'name': plant.nickname.isNotEmpty ? plant.nickname : plant.plantTypeName,
                  'location': 'In ${plant.category}',
                  'imageUrl': plant.imageUrl,
                })
            .toList();

        final donePlants = plants
            .where((plant) => 
                plant.status != 'NO_SENSOR' && 
                plant.status != 'MEASURING' &&
                plant.currentMoisture >= (plant.moistureRange['min'] ?? 0.0) &&
                plant.currentMoisture <= (plant.moistureRange['max'] ?? 100.0))
            .map((plant) => {
                  'plantId': plant.plantId,
                  'plantTypeId': plant.plantTypeId,
                  'name': plant.nickname.isNotEmpty ? plant.nickname : plant.plantTypeName,
                  'location': 'In ${plant.category}',
                  'imageUrl': plant.imageUrl,
                })
            .toList();

        if (filter == AppLocalizations.of(context).today) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  if (underwaterPlants.isNotEmpty)
                    UnderwaterPlantsCard(
                      plants: underwaterPlants,
                      count: underwaterPlants.length,
                    ),
                  if (inProgressPlants.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    InProgressPlantsCard(
                      plants: inProgressPlants,
                      count: inProgressPlants.length,
                    ),
                  ],
                  if (donePlants.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    DonePlantsCard(
                      plants: donePlants,
                      count: donePlants.length,
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        } else {
          // Only show underwater plants for Upcoming tab
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  if (underwaterPlants.isNotEmpty)
                    UnderwaterPlantsCard(
                      plants: underwaterPlants,
                      count: underwaterPlants.length,
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
