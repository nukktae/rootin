import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../screens/sensor_search_screen.dart';
import 'dart:developer' as dev;

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
    dev.log('Plant ID: ${widget.id}');
    dev.log('Plant Name: ${widget.plantName}');
    dev.log('Room Name: ${widget.roomName}');
    dev.log('Category ID: ${widget.categoryId}');
    dev.log('Image URL: ${widget.imageUrl}');

    try {
      final token = dotenv.env['FCM_TOKEN'];
      final response = await http.post(
        Uri.parse('https://api.rootin.me/v1/plants'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: json.encode({
          'plantTypeId': widget.id,
          'nickname': widget.plantName,
          'categoryId': widget.categoryId,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        dev.log('Plant registered successfully');
        _navigateToSensorSearch();
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to register plant'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      dev.log('Error registering plant: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to register plant: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
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
