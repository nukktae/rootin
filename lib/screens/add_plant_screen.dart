import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../l10n/app_localizations.dart';
import '../constants/api_constants.dart';
import '../models/plant.dart';
import './add_plant_detail_screen.dart';
import '../widgets/plant_search_bar.dart';
import '../widgets/plant_search_item.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddPlantScreen extends StatefulWidget {
  final String? plantTypeId;
  final String? plantName;
  final String? scientificName;
  final String? imageUrl;

  const AddPlantScreen({
    super.key,
    this.plantTypeId,
    this.plantName,
    this.scientificName,
    this.imageUrl,
  });

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  List<Plant> filteredPlants = [];
  List<Plant> allPlants = [];
  bool isLoading = true;
  Timer? _debounceTimer;

  void _handlePlantSelection(Plant plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPlantDetailScreen(
          plant: {
            'id': plant.id,
            'name': plant.name,
            'subname': plant.scientificName,
            'imageUrl': plant.imageUrl,
            'description': plant.description,
            'category': plant.category,
          },
        ),
      ),
    );
  }

  void _handleSearch(String query) async {
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      setState(() {
        filteredPlants = allPlants;
        isLoading = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        setState(() => isLoading = true);
        
        final token = dotenv.env['FCM_TOKEN'];
        final url = '${ApiConstants.getPlantTypesUrl()}?keyword=$query';
        
        final response = await http.get(
          Uri.parse(url),
          headers: {
            ApiConstants.authorizationHeader: '${ApiConstants.bearerPrefix} $token',
            'Content-Type': ApiConstants.contentType,
            'accept': ApiConstants.contentType,
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          final List<dynamic> rawData = jsonResponse['data'] as List<dynamic>;
          
          final List<Plant> searchResults = rawData.map((item) => Plant.fromJson({
            'id': item['id'],
            'name': item['name'],
            'scientificName': item['subname'] ?? '',
            'imageUrl': item['imageUrl'],
            'description': item['description'] ?? '',
            'category': item['category'] ?? '',
            // Add default values for required fields
            'plantId': '',
            'plantTypeId': item['id'],
            'nickname': '',
            'plantTypeName': item['name'],
            'status': '',
            'currentMoisture': 0.0,
            'moistureRange': {'min': 0.0, 'max': 0.0},
            'infoDifficulty': '',
            'infoWatering': '',
            'infoLight': '',
            'infoSoilType': '',
            'infoRepotting': '',
            'infoToxicity': '',
          })).toList();

          if (mounted) {
            setState(() {
              filteredPlants = searchResults;
              isLoading = false;
            });
          }
        }
      } catch (e) {
        print('Error searching plants: $e');
        setState(() => isLoading = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPlants();
  }

  Future<void> _fetchPlants() async {
    try {
      setState(() => isLoading = true);
      final token = dotenv.env['FCM_TOKEN'];
      
      final response = await http.get(
        Uri.parse(ApiConstants.getPlantTypesUrl()),
        headers: {
          ApiConstants.authorizationHeader: '${ApiConstants.bearerPrefix} $token',
          'Content-Type': ApiConstants.contentType,
          'accept': ApiConstants.contentType,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> rawData = jsonResponse['data'] as List<dynamic>;
        
        final List<Plant> plants = rawData.map((item) => Plant.fromJson({
          'id': item['id'],
          'name': item['name'],
          'scientificName': item['subname'] ?? '',
          'imageUrl': item['imageUrl'],
          'description': item['description'] ?? '',
          'category': item['category'] ?? '',
          // Add default values for required fields
          'plantId': '',
          'plantTypeId': item['id'],
          'nickname': '',
          'plantTypeName': item['name'],
          'status': '',
          'currentMoisture': 0.0,
          'moistureRange': {'min': 0.0, 'max': 0.0},
          'infoDifficulty': '',
          'infoWatering': '',
          'infoLight': '',
          'infoSoilType': '',
          'infoRepotting': '',
          'infoToxicity': '',
        })).toList();

        if (mounted) {
          setState(() {
            allPlants = plants;
            filteredPlants = plants;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching plants: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Hero(
                tag: 'addPlantHero',
                child: Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFEEEEEE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      'assets/icons/close.svg',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppLocalizations.of(context).identifyPlantFirst,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.22,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                AppLocalizations.of(context).searchByNameOrImage,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Inter',
                  color: Color(0xFF6F6F6F),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Search bar
            PlantSearchBar(onSearch: _handleSearch),
            const SizedBox(height: 24),
            // Plant list
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredPlants.length,
                      itemBuilder: (context, index) {
                        final plant = filteredPlants[index];
                        return Hero(
                          tag: 'plantHero-${plant.id}',
                          child: PlantSearchItem(
                            name: plant.name,
                            subname: plant.scientificName,
                            imageUrl: plant.imageUrl,
                            onTap: () => _handlePlantSelection(plant),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}