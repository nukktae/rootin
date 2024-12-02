import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../screens/sensor_search_screen.dart';
import '../constants/api_constants.dart';

class ConfirmPlantScreen extends StatefulWidget {
  final String id;
  final String plantName;
  final String roomName;
  final int categoryId;
  final String imageUrl;

  const ConfirmPlantScreen({
    super.key,
    required this.id,
    required this.plantName,
    required this.roomName,
    required this.categoryId,
    required this.imageUrl,
  });

  @override
  State<ConfirmPlantScreen> createState() => _ConfirmPlantScreenState();
}

class _ConfirmPlantScreenState extends State<ConfirmPlantScreen> {
  Future<void> _registerPlant(BuildContext context) async {
    try {
      final token = dotenv.env['FCM_TOKEN'];
      
      // 1. First create the plant
      const createUrl = '${ApiConstants.baseUrl}/v1/plants';
      debugPrint('Creating plant with data: ${widget.id}, ${widget.categoryId}, ${widget.imageUrl}');
      
      final createResponse = await http.post(
        Uri.parse(createUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'plantTypeId': widget.id,
          'categoryId': widget.categoryId,
          'imageUrl': widget.imageUrl,
        }),
      );

      debugPrint('Create Response: ${createResponse.body}');

      if (createResponse.statusCode == 200 || createResponse.statusCode == 201) {
        // Get the list of plants to find the most recently created one
        const getUrl = '${ApiConstants.baseUrl}/v1/plants';
        final getResponse = await http.get(
          Uri.parse(getUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
          },
        );

        if (getResponse.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(getResponse.body);
          final List<dynamic> plants = data['data'] as List;
          
          // Find the most recently created plant with matching plantTypeId
          final recentPlant = plants.firstWhere(
            (plant) => plant['plantTypeId'] == widget.id,
            orElse: () => null,
          );

          if (recentPlant == null) {
            throw Exception('Could not find newly created plant');
          }

          final plantId = recentPlant['plantId'];
          debugPrint('Found plant ID: $plantId');

          // 2. Then update the nickname using PUT endpoint
          final updateUrl = '${ApiConstants.baseUrl}/v1/plants/$plantId';
          debugPrint('Updating plant with nickname: ${widget.plantName}');
          
          final updateResponse = await http.put(
            Uri.parse(updateUrl),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'plantTypeId': widget.id,
              'categoryId': widget.categoryId,
              'imageUrl': widget.imageUrl,
              'nickname': widget.plantName,
            }),
          );

          debugPrint('Update Response: ${updateResponse.body}');

          if (updateResponse.statusCode == 200) {
            if (mounted) {
              _navigateToSensorSearch();
            }
          } else {
            throw Exception('Failed to update plant nickname: ${updateResponse.statusCode}');
          }
        } else {
          throw Exception('Failed to get plants: ${getResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to create plant: ${createResponse.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in plant registration: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register plant: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToSensorSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SensorSearchScreen(
          plantNickname: widget.plantName,
          imageUrl: widget.imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Back Button with adjusted padding
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE7E7E7),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/arrow.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                'Ready to add the plant?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  letterSpacing: -0.22,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Text(
                'Feel free to skip for now—you can easily add later in the plant\'s detail settings.',
                style: TextStyle(
                  color: Color(0xFF6F6F6F),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  letterSpacing: -0.28,
                ),
              ),

              const SizedBox(height: 40),

              // Plant Image and Details
              const SizedBox(height: 32),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 185.51,
                        height: 185.51,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUrl),
                            fit: BoxFit.fill,
                            onError: (exception, stackTrace) => const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 102,
                        child: Text(
                          widget.plantName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            letterSpacing: -0.22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 102,
                        child: Text(
                          'In ${widget.roomName}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF6F6F6F),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            letterSpacing: -0.16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => _registerPlant(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Add Plant",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6F6F6F),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
