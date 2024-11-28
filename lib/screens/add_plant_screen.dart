import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/api_constants.dart';
import '../models/plant.dart';
import './confirm_plant_screen.dart';

class AddPlantScreen extends StatefulWidget {
  final String plantTypeId;
  final String plantName;
  final String scientificName;
  final String imageUrl;

  const AddPlantScreen({
    super.key,
    required this.plantTypeId,
    required this.plantName,
    required this.scientificName,
    required this.imageUrl,
  });

  @override
  AddPlantScreenState createState() => AddPlantScreenState();
}

class AddPlantScreenState extends State<AddPlantScreen> {
  List<Plant> plantList = [];
  List<Plant> filteredPlantList = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  
  // Add these state variables
  String selectedRoom = 'Living Room';
  int selectedCategoryId = 1;

  final List<Map<String, dynamic>> rooms = [
    {'name': 'Living Room', 'categoryId': 1},
    {'name': 'Kitchen', 'categoryId': 2},
    {'name': 'Bathroom', 'categoryId': 3},
    {'name': 'Office', 'categoryId': 4},
    {'name': 'Bedroom', 'categoryId': 5},
    {'name': 'Desk', 'categoryId': 6},
    {'name': 'Lounge', 'categoryId': 7},
  ];

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
        
        // Convert each item to a Plant object
        final List<Plant> plants = rawData.map((item) {
          // Ensure each item is a Map<String, dynamic>
          final Map<String, dynamic> plantData = Map<String, dynamic>.from(item);
          return Plant.fromJson(plantData);
        }).toList();

        if (mounted) {
          setState(() {
            plantList = plants;
            filteredPlantList = List<Plant>.from(plants);
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
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildRoomSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: DropdownButtonFormField<String>(
        value: selectedRoom,
        decoration: const InputDecoration(
          labelText: 'Select Room',
          border: OutlineInputBorder(),
        ),
        items: rooms.map<DropdownMenuItem<String>>((room) {
          return DropdownMenuItem<String>(
            value: room['name'] as String,
            child: Text(room['name'] as String),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedRoom = newValue;
              selectedCategoryId = rooms.firstWhere(
                (room) => room['name'] == newValue
              )['categoryId'] as int;
            });
          }
        },
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          filteredPlantList = plantList.where((plant) {
            final name = plant.name.toLowerCase();
            final scientificName = plant.scientificName.toLowerCase();
            final searchLower = query.toLowerCase();
            return name.contains(searchLower) || scientificName.contains(searchLower);
          }).toList();
        });
      }
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search plants...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Future<void> _ensureRoomCategory() async {
    try {
      final token = dotenv.env['FCM_TOKEN'];
      
      final response = await http.put(
        Uri.parse(ApiConstants.createCategoryUrl()),
        headers: {
          ApiConstants.authorizationHeader: '${ApiConstants.bearerPrefix} $token',
          'Content-Type': ApiConstants.contentType,
          'accept': ApiConstants.contentType,
        },
        body: json.encode({
          'name': selectedRoom,
          'categoryId': selectedCategoryId,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Failed to create category: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error creating category: $e');
    }
  }

  void _handlePlantSelection() async {
    await _ensureRoomCategory();
    
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmPlantScreen(
            id: widget.plantTypeId,
            plantName: widget.plantName,
            roomName: selectedRoom,
            categoryId: selectedCategoryId,
            imageUrl: widget.imageUrl,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildRoomSelector(),
            _buildSearchBar(),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredPlantList.length,
                      itemBuilder: (context, index) {
                        final plant = filteredPlantList[index];
                        return ListTile(
                          leading: Image.network(
                            plant.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          ),
                          title: Text(plant.name),
                          subtitle: Text(plant.scientificName),
                          onTap: () => _handlePlantSelection(),
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
