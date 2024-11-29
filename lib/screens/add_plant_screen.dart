import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/api_constants.dart';
import '../models/plant.dart';
import './add_plant_detail_screen.dart';
import '../widgets/plant_search_bar.dart';
import '../widgets/plant_search_item.dart';

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
            'scientificName': plant.scientificName,
            'imageUrl': plant.imageUrl,
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
        print('Searching plants with URL: $url');
        
        final response = await http.get(
          Uri.parse(url),
          headers: {
            ApiConstants.authorizationHeader: '${ApiConstants.bearerPrefix} $token',
            'Content-Type': ApiConstants.contentType,
            'accept': ApiConstants.contentType,
          },
        );

        print('Search response status: ${response.statusCode}');
        print('Search response body: ${response.body}');

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);
          final List<dynamic> rawData = jsonResponse['data'] as List<dynamic>;
          
          final List<Plant> searchResults = rawData.map((item) {
            return Plant.fromJson({
              'id': item['id'],
              'name': item['name'],
              'subname': item['subname'],
              'imageUrl': item['imageUrl'],
            });
          }).toList();

          print('Parsed ${searchResults.length} results');

          if (mounted) {
            setState(() {
              filteredPlants = searchResults;
              isLoading = false;
            });
          }
        } else {
          print('Failed to search plants: ${response.statusCode}');
          print('Response body: ${response.body}');
          setState(() => isLoading = false);
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
        
        final List<Plant> plants = rawData.map((item) {
          final Map<String, dynamic> plantData = Map<String, dynamic>.from(item);
          return Plant.fromJson(plantData);
        }).toList();

        if (mounted) {
          setState(() {
            allPlants = List<Plant>.from(plants);
            filteredPlants = List<Plant>.from(plants);
          });
        }
      } else {
        print('Failed to fetch plants: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching plants: $e');
      print('Stack trace: $stackTrace');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
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
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF5F5F5),
                  shape: const CircleBorder(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Identify your plant',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Search by plant name or use an image to identify.',
                style: TextStyle(
                  fontSize: 16,
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
                        return PlantSearchItem(
                          name: plant.name,
                          subname: plant.scientificName,
                          imageUrl: plant.imageUrl,
                          onTap: () => _handlePlantSelection(plant),
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
