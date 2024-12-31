import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/plant.dart';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../services/data_transformer_service.dart';
import 'dart:math' as math;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showNotification(RemoteMessage message) async {
  const androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );

  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const details = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? 'New Message',
    message.notification?.body ?? '',
    details,
    payload: message.data.toString(),
  );
}
class PlantService {
  late final Dio _dio;
  final DataTransformerService _transformer = DataTransformerService();
  
  PlantService() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    String? token = await _getValidToken();  // Get fresh token
    
    _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'https://api.rootin.me',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token != null ? 'Bearer $token' : '',
      },
    ));

    // Add interceptor for token refresh
    _dio.interceptors.clear();  // Clear existing interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Always get fresh token before request
        final currentToken = await _getValidToken();
        if (currentToken != null) {
          options.headers['Authorization'] = 'Bearer $currentToken';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 403) {
          // Force token refresh
          final newToken = await FirebaseMessaging.instance.getToken(vapidKey: dotenv.env['VAPID_KEY']);
          if (newToken != null) {
            error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await _dio.fetch(error.requestOptions);
            return handler.resolve(retryResponse);
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<String?> _getValidToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        dotenv.env['FCM_TOKEN'] = token;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', token);
        return token;
      }
      return null;
    } catch (e) {
      dev.log('Error getting FCM token: $e');
      return null;
    }
  }

  Future<List<Plant>> getPlants() async {
    try {
      final token = await _getValidToken();
      if (token == null) {
        dev.log('FCM token not available');
        return [];
      }

      const url = '${ApiConstants.baseUrl}/${ApiConstants.apiVersion}/plants';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> plantsJson = jsonResponse['data'] ?? [];
        return plantsJson.map((json) => Plant.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        // If token is invalid, try to get a new one and retry once
        final newToken = await FirebaseMessaging.instance.getToken();
        if (newToken != null) {
          dotenv.env['FCM_TOKEN'] = newToken;
          return getPlants(); // Retry with new token
        }
      }
      return [];
    } catch (e) {
      dev.log('Error fetching plants: $e');
      return [];
    }
  }

  Future<Plant> getPlantDetail(String plantId) async {
    try {
      final token = await _getValidToken();
      if (token == null) {
        dev.log('FCM token not available');
        throw Exception('FCM token not available');
      }

      final url = '${ApiConstants.baseUrl}/${ApiConstants.apiVersion}/plants/$plantId';
      dev.log('Fetching plant details from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      dev.log('Plant detail response status: ${response.statusCode}');
      dev.log('Plant detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final plantData = jsonResponse['data'];
        
        return Plant.fromJson({
          'id': plantData['id'] ?? '',
          'plantId': plantData['plantId'] ?? '',
          'plantTypeId': plantData['plantTypeId'] ?? '',
          'name': plantData['name'] ?? '',
          'nickname': plantData['nickname'] ?? '',
          'plantTypeName': plantData['plantTypeName'] ?? '',
          'scientificName': plantData['scientificName'] ?? '',
          'imageUrl': plantData['imageUrl'] ?? '',
          'description': plantData['description'] ?? '',
          'category': plantData['category'] ?? '',
          'status': plantData['status'] ?? '',
          'currentMoisture': plantData['currentMoisture'] ?? 0.0,
          'moistureRange': {
            'min': plantData['moistureRange']?['min'] ?? 0.0,
            'max': plantData['moistureRange']?['max'] ?? 0.0,
          },
          'infoDifficulty': plantData['infoDifficulty'] ?? '',
          'infoWatering': plantData['infoWatering'] ?? '',
          'infoLight': plantData['infoLight'] ?? '',
          'infoSoilType': plantData['infoSoilType'] ?? '',
          'infoRepotting': plantData['infoRepotting'] ?? '',
          'infoToxicity': plantData['infoToxicity'] ?? '',
        });
      }
      throw Exception('Failed to load plant details: ${response.statusCode}');
    } catch (e) {
      dev.log('Error in getPlantDetail: $e');
      throw Exception('Failed to load plant details');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPlantHistory(String token) async {
    try {
      final url = 'https://1odd45uk4i.execute-api.us-west-1.amazonaws.com/sleep/detail?token=$token';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        final Map<String, Map<String, dynamic>> hourlyData = {};
        
        for (var item in responseData) {
          final timestamp = int.parse(item['timestamp'].toString());
          final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final value = (item['event_values'] as List).first;
          final plantId = item['plant_id'];
          
          final hourKey = '${dateTime.year}-${dateTime.month}-${dateTime.day}-${dateTime.hour}';
          final key = '$hourKey-$plantId';
          
          if (!hourlyData.containsKey(key) || 
              (hourlyData[key]!['timestamp'] as int) < timestamp) {
            hourlyData[key] = {
              'plant_id': plantId,
              'event_values': [value],
              'timestamp': timestamp,
              'plant_name': item['plant_name'],
              'humidity_min': item['humidity_min'],
              'humidity_max': item['humidity_max'],
            };
          }
        }
        
        final List<Map<String, dynamic>> sortedData = hourlyData.values.toList()
          ..sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
        
        return sortedData;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> fetchPlants() async {
    final token = await _getValidToken();
    if (token == null) {
      dev.log('Could not obtain valid FCM token');
      return [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('https://api.rootin.me/v1/plants'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? [];
      } else if (response.statusCode == 403) {
        // Token is invalid, try to refresh it
        final newToken = await FirebaseMessaging.instance.getToken();
        if (newToken != null) {
          dotenv.env['FCM_TOKEN'] = newToken;
          // Retry the request with new token
          return fetchPlants();
        }
      }
      dev.log('Failed to fetch plants: ${response.statusCode} - ${response.body}');
      return [];
    } catch (e) {
      dev.log('Error fetching plants: $e');
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
      final hojunData = await fetchPlants();
      final kihoonData = await fetchPlantHistory(dotenv.env['FCM_TOKEN'] ?? '');

      // Transform and combine the data
      final combinedData = _transformer.combineAndTransformData(
        hojunData,
        kihoonData.toList(),
      );

      // Convert to Plant objects
      return combinedData.map((data) => Plant.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching combined plant data: $e');
      rethrow;
    }
  }

  Future<bool> verifyToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/${ApiConstants.apiVersion}/verify-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      dev.log('Error verifying token: $e');
      return false;
    }
  }

  Future<void> updatePlantImage({
    required String plantId,
    required File imageFile,
  }) async {
    try {
      final token = await _getValidToken();
      if (token == null) throw Exception('Authentication token not available');

      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConstants.baseUrl}/${ApiConstants.apiVersion}/plants/$plantId/image'),
      );

      // Add authorization header
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Add file to request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode != 200) {
        throw Exception('Server returned status code: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      dev.log('Error updating plant image: $e');
      rethrow;
    }
  }
}
