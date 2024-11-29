import 'package:flutter/material.dart';

class AppGuideScreen extends StatelessWidget {
  const AppGuideScreen({super.key});

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          letterSpacing: -0.28,
        ),
        backgroundColor: const Color(0xFFEEEEEE),
        selectedColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onSelected: (bool selected) {
          // Handle filter selection
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFEEEEEE),
                      shape: CircleBorder(),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'App guide',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.28,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('Register Sensor', false),
                          _buildFilterChip('Status', true),
                          _buildFilterChip('Notifications', false),
                          _buildFilterChip('FAQ', false),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    const Text(
                      "How is a Plant's Status Determined?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.22,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "A plant's status is determined based on data collected from sensors. The following are the typical statuses and their criteria:",
                      style: TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.28,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Container(
                      width: double.infinity,
                      height: 135,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/appguide.png',
                          fit: BoxFit.cover,
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