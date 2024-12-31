import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatusContent extends StatelessWidget {
  const StatusContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        _buildStatusItem(
          title: 'Ideal',
          description: 'Soil moisture is within the optimal range for your plant.',
          color: const Color(0xFF73C2FB),
          iconPath: 'assets/icons/status_ideal.svg',
        ),
        _buildStatusItem(
          title: 'Needs Water',
          description: 'Soil moisture is below the recommended range.',
          color: const Color(0xFFD4B500),
          iconPath: 'assets/icons/status_underwater.svg',
        ),
        _buildStatusItem(
          title: 'Overwatered',
          description: 'Soil moisture is slightly above the recommended range.',
          color: const Color(0xff24494E),
          iconPath: 'assets/icons/status_overwater.svg',
        ),
        _buildStatusItem(
          title: 'Waterlogged',
          description: 'Soil moisture is significantly above the recommended range.',
          color: const Color(0xFF000000),
          iconPath: 'assets/icons/status_waterlogged.svg',
        ),
        _buildStatusItem(
          title: 'Measuring',
          description: 'Sensor is currently measuring or initializing.',
          color: const Color(0xFF757575),
          iconPath: 'assets/icons/status_measuring.svg',
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
    );
  }

  Widget _buildStatusItem({
    required String title,
    required String description,
    required Color color,
    required String iconPath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: ShapeDecoration(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.28,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 