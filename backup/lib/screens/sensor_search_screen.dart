import 'package:flutter/material.dart';
import '../widgets/bluetooth_search_modal.dart';

class SensorSearchScreen extends StatelessWidget {
  final String plantNickname;
  final String imageUrl;

  const SensorSearchScreen({
    super.key,
    required this.plantNickname,
    required this.imageUrl,
  });

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
              
              // Back Button
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(height: 40),

              // Title and Description
              const Text(
                'Connect your sensor',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Search for your sensor and connect it to your plant.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6F6F6F),
                ),
              ),

              const Spacer(),

              // Search Sensor Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => BluetoothSearchModal(
                        plantNickname: plantNickname,
                        imageUrl: imageUrl,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Search Sensor',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
} 