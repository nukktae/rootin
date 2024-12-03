import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/plant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../services/data_transformer_service.dart';
import 'dart:math' as math;

class PlantService {
  late final Dio _dio;
  final DataTransformerService _transformer = DataTransformerService();
  
  PlantService() {
    final token = dotenv.env['FCM_TOKEN'];
    if (token == null || token.isEmpty) {
      throw Exception('FCM_TOKEN is not configured in .env file');
    }

    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'https://api.rootin.me',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<List<Plant>> getPlants() async {
    try {
      final token = dotenv.env['FCM_TOKEN'];
      if (token == null || token.isEmpty) {
        throw Exception('FCM token not available');
      }

      const url = '${ApiConstants.baseUrl}/${ApiConstants.apiVersion}/plants';
      print('Making request to: $url');
      print('Using token: $token');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> plantsJson = jsonResponse['data'] ?? [];
        return plantsJson.map((json) => Plant.fromJson(json)).toList();
      } else {
        // Try to parse error message if available
        try {
          final errorJson = json.decode(response.body);
          print('Detailed error: ${errorJson['message'] ?? errorJson['error'] ?? response.body}');
        } catch (e) {
          print('Raw error body: ${response.body}');
        }
        return [];
      }
    } catch (e, stackTrace) {
      print('Error fetching plants: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<Plant> getPlantDetail(String plantId) async {
    try {
      final response = await _dio.get('/v1/plants/$plantId');
      if (response.statusCode == 200 && response.data != null) {
        return Plant.fromJson(response.data['data']);
      }
      throw Exception('Plant not found');
    } catch (e) {
      print('Error in getPlantDetail: $e');
      throw Exception('Failed to load plant details');
    }
  }

  Future<void> updatePlant(String plantId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/v1/plants/$plantId', data: data);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update plant: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in updatePlant: $e');
      throw Exception('Failed to update plant');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPlantHistory(String token) async {
    final response = await http.get(
      Uri.parse('https://1odd45uk4i.execute-api.us-west-1.amazonaws.com/sleep/detail?token=$token'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load plant history');
    }
  }

  Future<List<dynamic>> fetchPlants() async {
    final String? fcmToken = dotenv.env['FCM_TOKEN'];
    
    final response = await http.get(
      Uri.parse('https://api.rootin.me/v1/plants'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $fcmToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'] ?? [];
    } else {
      print('Failed to fetch plants: ${response.statusCode}');
      return [];
    }
  }

  Future<void> registerPlant({
    required String plantTypeId,
    required int categoryId,
    required String nickname,
    required String imageUrl,
    required String plantName,
    required String plantSubname,
  }) async {
    try {
      final token = dotenv.env['FCM_TOKEN'];
      if (token == null) throw Exception('FCM Token not found');

      // Generate a proper plant type ID
      final generatedPlantTypeId = plantName.toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll(RegExp(r'[^a-z0-9_]'), '')
          .substring(0, math.min(8, plantName.length)) + 
          DateTime.now().millisecondsSinceEpoch.toString().substring(8);

      print('Generated plant type ID: $generatedPlantTypeId');

      // Step 1: Create Plant Type
      final plantTypeData = {
        "id": generatedPlantTypeId,
        "name": plantName,
        "scientificName": plantSubname,
        "description": "Common houseplant",
        "imageUrl": imageUrl,
        "careInstructions": {
          "toxicity": "Non-toxic",
          "difficulty": "Easy",
          "repotting": "1-2 Years",
          "watering": "1-2 Weeks",
          "light": "Partial Sun",
          "soilType": "Well-Drain"
        }
      };

      print('Creating plant type with data: $plantTypeData');

      final createTypeResponse = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/${ApiConstants.apiVersion}/plant-types'),
        headers: {
          ApiConstants.authorizationHeader: '${ApiConstants.bearerPrefix} $token',
          'Content-Type': ApiConstants.contentType,
        },
        body: jsonEncode(plantTypeData),
      );

      print('Create plant type response: ${createTypeResponse.statusCode}');
      print('Create plant type body: ${createTypeResponse.body}');

      if (createTypeResponse.statusCode != 201 && createTypeResponse.statusCode != 409) {
        throw Exception('Failed to create plant type: ${createTypeResponse.body}');
      }

      // Step 2: Register Plant
      final plantData = {
        "plantTypeId": generatedPlantTypeId,  // Use the generated ID
        "categoryId": categoryId,
        "nickname": nickname,
        "imageUrl": imageUrl,
        "status": "NO_SENSOR",
        "moisture_range": [30, 70],
        "current_moisture": 0
      };

      print('Registering plant with data: $plantData');

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/${ApiConstants.apiVersion}/plants'),
        headers: {
          ApiConstants.authorizationHeader: '${ApiConstants.bearerPrefix} $token',
          'Content-Type': ApiConstants.contentType,
        },
        body: jsonEncode(plantData),
      );

      print('Register plant response: ${response.statusCode}');
      print('Register plant body: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Failed to register plant: ${response.body}');
      }

      print('Plant registered successfully');

    } catch (e) {
      print('Error in plant registration process: $e');
      rethrow;
    }
  }

  String _getCategoryName(int categoryId) {
    final Map<int, String> categories = {
      1: 'Living Room',
      2: 'Kitchen',
      3: 'Bathroom',
      4: 'Office',
      5: 'Bedroom',
    };
    return categories[categoryId] ?? 'Home';
  }

  Future<List<Plant>> fetchCombinedPlantData() async {
    try {
      // Fetch data from both APIs
      final hojunData = await fetchPlants();  // Your existing fetchPlants method
      final kihoonData = await fetchPlantHistory(dotenv.env['FCM_TOKEN'] ?? '');

      // Transform and combine the data
      final combinedData = _transformer.combineAndTransformData(
        hojunData,
        kihoonData
      );

      // Convert to Plant objects
      return combinedData.map((data) => Plant.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching combined plant data: $e');
      rethrow;
    }
  }
}