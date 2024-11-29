import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../widgets/filter_modal.dart';
import '../widgets/care_banner.dart';
import '../widgets/plant_grid_view.dart';
import '../screens/add_plant_screen.dart';
import '../widgets/rootin_header.dart';
import '../widgets/ai_chat_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> plantData = [];
  String selectedStatus = 'All Status';
  String selectedLocation = 'All Locations';
  String selectedRoom = 'All Rooms';

  @override
  void initState() {
    super.initState();
    _requestFCMToken();
    _setupFCMListeners();
    _refreshPlants();
  }

  Future<void> _requestFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      log("FCM Token: $token");
        } catch (e) {
      log("Error retrieving FCM Token: $e");
    }
  }

  void _setupFCMListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground FCM Message Received: ${message.notification?.title} - ${message.notification?.body}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Background FCM Message Opened: ${message.notification?.title} - ${message.notification?.body}");
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    log("Background FCM Message Received: ${message.notification?.title} - ${message.notification?.body}");
  }

  Future<List<dynamic>> fetchPlants() async {
    final url = Uri.parse('https://api.rootin.me/v1/plants');
    final String? fcmToken = dotenv.env['FCM_TOKEN'];

    if (fcmToken == null || fcmToken.isEmpty) {
      log('FCM Token is not defined. Check your .env file.');
      return [];
    }

    final headers = {
      'accept': 'application/json',
      'Authorization': 'Bearer $fcmToken',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        log('API Response: ${response.body}');
        return responseData['data'] ?? [];
      } else {
        log('Failed to load plants data: ${response.statusCode}');
        log('Error response: ${response.body}');
        return [];
      }
    } catch (e) {
      log('Error fetching plant data: $e');
      return [];
    }
  }

  Future<void> _refreshPlants() async {
    final plants = await fetchPlants();

    if (plants.isEmpty) {
      log("No plants returned from API");
    } else {
      log("Total plants fetched: ${plants.length}");
    }

    setState(() {
      plantData = plants.where((plant) {
        final plantStatus = plant['status'];
        final plantCategory = plant['category'];
        final room = plantCategory.split('/').last; // Extract room from category

        log("Evaluating plant: ${plant['nickname']} - Status: $plantStatus, Category: $plantCategory, Room: $room");

        // Status filter
        if (selectedStatus != 'All Status' && plantStatus != selectedStatus) {
          log("Plant excluded due to status filter. Expected: $selectedStatus, Found: $plantStatus");
          return false;
        }

        // Location filter
        if (selectedLocation != 'All Locations' && plantCategory != selectedLocation) {
          log("Plant excluded due to location filter. Expected: $selectedLocation, Found: $plantCategory");
          return false;
        }

        // Room filter
        if (selectedRoom != 'All Rooms' && room != selectedRoom) {
          log("Plant excluded due to room filter. Expected: $selectedRoom, Found: $room");
          return false;
        }

        log("Plant included.");
        return true;
      }).toList();
    });

    log("Filtered plants count: ${plantData.length}");
  }

  int getUnderwaterCount() {
    return plantData.where((plant) {
      final moistureRange = plant['moisture_range'] as List<dynamic>?;
      final currentMoisture = plant['current_moisture'] as int?;
      if (moistureRange != null && currentMoisture != null) {
        final minMoisture = moistureRange.first as int;
        return currentMoisture < minMoisture;
      }
      return false;
    }).length;
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterModal(
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
        );
      },
    );
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
                      CareBanner(underwaterCount: getUnderwaterCount()),
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
                          plants: plantData,
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
      floatingActionButton: const AIChatFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
