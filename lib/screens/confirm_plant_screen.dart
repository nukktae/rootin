import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ConfirmPlantScreen extends StatelessWidget {
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

  Future<void> _registerPlant(BuildContext context) async {
    try {
      final String? fcmToken = dotenv.env['FCM_TOKEN'];
      
      if (id.isEmpty) {
        throw Exception('Plant type ID is missing');
      }
      
      print('Starting plant registration with:');
      print('PlantTypeId: $id');
      print('CategoryId: $categoryId');
      print('Nickname: $plantName');
      print('ImageUrl: $imageUrl');
      print('RoomName: $roomName');
      
      final plantData = {
        'plantTypeId': id,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
        'nickname': plantName,
        'roomName': roomName,
      };

      print('Sending request with data: ${jsonEncode(plantData)}');

      final response = await http.post(
        Uri.parse('https://api.rootin.me/v1/plants'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'Authorization': 'Bearer $fcmToken',
        },
        body: jsonEncode(plantData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$plantName added successfully!')),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception('Failed to register plant: ${errorBody['detail']}');
      }
    } catch (e) {
      print('Error registering plant: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add plant: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            image: NetworkImage(imageUrl),
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
                          plantName,
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
                          'In $roomName',
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
