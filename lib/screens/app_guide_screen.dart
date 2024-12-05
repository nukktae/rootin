import 'package:flutter/material.dart';
import '../widgets/app_guide/register_sensor_content.dart';
import '../widgets/app_guide/notifications_content.dart';
import '../widgets/app_guide/faq_content.dart';
import '../widgets/app_guide/status_content.dart';

class AppGuideScreen extends StatefulWidget {
  const AppGuideScreen({super.key});

  @override
  State<AppGuideScreen> createState() => _AppGuideScreenState();
}

class _AppGuideScreenState extends State<AppGuideScreen> {
  String _currentSection = 'Status';

  Widget _getContent() {
    switch (_currentSection) {
      case 'Register Sensor':
        return const RegisterSensorContent();
      case 'Notifications':
        return const NotificationsContent();
      case 'FAQ':
        return const FAQContent();
      default:
        return const StatusContent(); // You'll need to create this widget
    }
  }

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
          setState(() {
            _currentSection = label;
          });
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
                          _buildFilterChip('Register Sensor', _currentSection == 'Register Sensor'),
                          _buildFilterChip('Status', _currentSection == 'Status'),
                          _buildFilterChip('Notifications', _currentSection == 'Notifications'),
                          _buildFilterChip('FAQ', _currentSection == 'FAQ'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _getContent(),
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