import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/plant.dart';
import '../widgets/filter_modal.dart';
import '../widgets/care_banner.dart';
import '../widgets/plant_grid_view.dart';
import '../screens/add_plant_screen.dart';
import '../widgets/rootin_header.dart';
import '../widgets/ai_chat_fab.dart';
import '../services/plant_service.dart';
import '../services/notification_service.dart';
import '../widgets/filter_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) setCurrentIndex;

  const HomeScreen({
    super.key,
    required this.setCurrentIndex,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Plant> plantData = [];
  String selectedStatus = 'All Status';
  String selectedLocation = 'All Locations';
  String selectedRoom = 'All Rooms';

  @override
  void initState() {
    super.initState();
    _testFCM();
    _requestFCMToken();
    _setupFCMListeners();
    _refreshPlants();
  }

  Future<void> _testFCM() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    developer.log('FCM Token: $fcmToken');

    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    developer.log('Notification settings: ${settings.authorizationStatus}');
  }

  Future<void> _requestFCMToken() async {
    try {
      // Request notification permissions first
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get fresh token
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          developer.log("FCM Token: $token");
          
          // Save token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('fcm_token', token);
          dotenv.env['FCM_TOKEN'] = token;
          
          // Register token with backend
          await _registerTokenWithBackend(token);
        } else {
          developer.log('FCM Token is not available');
        }
      } else {
        developer.log('Notification permissions not granted');
      }
    } catch (e) {
      developer.log("Error in FCM setup: $e");
      // Don't show error to user, just log it
    }
  }

  Future<void> _registerTokenWithBackend(String token) async {
    try {
      final url = Uri.parse('https://api.rootin.me/v1/register');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'fcm_token': token}),
      );

      if (response.statusCode == 200) {
        developer.log("Token registered successfully");
      } else {
        developer.log("Token registration failed with status: ${response.statusCode}");
      }
    } catch (e) {
      developer.log("Error registering token: $e");
    }
  }

  void _setupFCMListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      developer.log('========= Foreground Message Debug =========');
      developer.log('Message data: ${message.data}');
      
      if (message.data.containsKey('body')) {
        try {
          final bodyJson = jsonDecode(message.data['body']);
          developer.log('Parsed foreground message body: $bodyJson');
          developer.log('Image URL from foreground: ${bodyJson['image_url']}');
        } catch (e) {
          developer.log('Error parsing foreground message body: $e');
        }
      }
      developer.log('=========================================');

      NotificationService().showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log('========= Message Opened Debug =========');
      developer.log('Opened message data: ${message.data}');
    });
  }

  Future<List<Plant>> fetchPlants() async {
    final url = Uri.parse('https://api.rootin.me/v1/plants');
    final String? fcmToken = dotenv.env['FCM_TOKEN'];

    if (fcmToken == null || fcmToken.isEmpty) {
      developer.log('FCM Token is not available');
      return [];
    }

    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $fcmToken',
    };

    try {
      final response = await http.get(url, headers: headers);
      developer.log('Plants API Response: ${response.statusCode} - ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> plantsJson = jsonResponse['data'] ?? [];
        return plantsJson.map((json) => Plant.fromJson(json)).toList();
      } else {
        developer.log('Failed to fetch plants: ${response.statusCode} ${response.body}');
        return [];
      }
    } catch (e) {
      developer.log('Error fetching plants: $e');
      return [];
    }
  }

  Future<void> _refreshPlants() async {
    try {
      developer.log('Refreshing plants...');
      final plantService = PlantService();
      final plants = await plantService.getPlants();
      developer.log('Fetched ${plants.length} plants');
      
      if (mounted) {
        setState(() {
          plantData = plants;
        });
      }
    } catch (e) {
      developer.log('Error in _refreshPlants: $e');
      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load plants. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  int getUnderwaterCount() {
    try {
      return plantData.where((plant) {
        // Exclude plants with UNKNOWN or NO_SENSOR status
        if (plant.status == 'UNKNOWN' || plant.status == 'NO_SENSOR') {
          return false;
        }
        // Access the moistureRange property of the Plant class
        final minMoisture = plant.moistureRange['min'] ?? 0.0;
        return plant.currentMoisture < minMoisture;
      }).length;
    } catch (e) {
      developer.log('Error calculating underwater count: $e');
      return 0;
    }
  }

  int getOverwaterCount() {
    try {
      return plantData.where((plant) {
        // Exclude plants with UNKNOWN or NO_SENSOR status
        if (plant.status == 'UNKNOWN' || plant.status == 'NO_SENSOR') {
          return false;
        }
        // Access the moistureRange property of the Plant class
        final maxMoisture = plant.moistureRange['max'] ?? 100.0;
        return plant.currentMoisture > maxMoisture;
      }).length;
    } catch (e) {
      developer.log('Error calculating overwater count: $e');
      return 0;
    }
  }

  int getHealthyCount() {
    try {
      return plantData.where((plant) {
        // Exclude plants with UNKNOWN or NO_SENSOR status
        if (plant.status == 'UNKNOWN' || plant.status == 'NO_SENSOR') {
          return false;
        }
        final minMoisture = plant.moistureRange['min'] ?? 0.0;
        final maxMoisture = plant.moistureRange['max'] ?? 100.0;
        return plant.currentMoisture >= minMoisture && 
               plant.currentMoisture <= maxMoisture;
      }).length;
    } catch (e) {
      developer.log('Error calculating healthy count: $e');
      return 0;
    }
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        selectedStatus: selectedStatus,
        selectedLocation: selectedLocation,
        selectedRoom: selectedRoom,
        onApply: (status, location, room) {
          setState(() {
            selectedStatus = status;
            selectedLocation = location;
            selectedRoom = room;
          });
          _refreshPlants();
        },
      ),
    );
  }

  List<Plant> getFilteredPlants() {
    return plantData.where((plant) {
      // Status filter
      if (selectedStatus != 'All Status') {
        String plantStatus = '';
        if (plant.status == 'HEALTHY') plantStatus = 'Ideal';
        else if (plant.status == 'UNDERWATER') plantStatus = 'Underwatered';
        else if (plant.status == 'OVERWATER') plantStatus = 'Overwatered';
        else if (plant.status == 'WATERLOGGED') plantStatus = 'Water-logged';
        
        if (plantStatus != selectedStatus) return false;
      }

      // Location filter
      if (selectedLocation != 'All Locations' && 
          plant.category.split('/')[0] != selectedLocation) {
        return false;
      }

      // Room filter
      if (selectedRoom != 'All Rooms' && 
          plant.category.split('/').last != selectedRoom) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
                child: Row(
                  children: [
                    const RootinHeader(),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddPlantScreen(),
                        ),
                      ),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEEEEE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF8E8E8E),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Today's watering",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                          letterSpacing: -0.22,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CareBanner(
                        underwaterCount: getUnderwaterCount(),
                        setCurrentIndex: widget.setCurrentIndex,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'My plants',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.22,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _openFilterModal,
                            child: Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFEEEEEE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/filter_icon.svg',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Transform.translate(
                        offset: const Offset(0, -30),
                        child: PlantGridView(
                          plants: getFilteredPlants(),
                          emptyMessage: "Try to add a plant!",
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const AIChatFAB(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}