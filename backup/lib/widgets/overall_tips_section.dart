import 'package:flutter/material.dart';

class OverallTipsSection extends StatelessWidget {
  final Map<String, dynamic> careTips;

  const OverallTipsSection({
    super.key,
    required this.careTips,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Overall Tips',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
              children: [
                _buildTipItem('Difficulty', careTips['Difficulty'] ?? 'N/A'),
                _buildTipItem('Watering', careTips['Watering'] ?? 'N/A'),
                _buildTipItem('Sunlight', careTips['Light'] ?? 'N/A'),
                _buildTipItem('Soil Type', careTips['Soil Type'] ?? 'N/A'),
                _buildTipItem('Repotting', careTips['Repotting'] ?? 'N/A'),
                _buildTipItem('Toxicity', careTips['Toxicity'] ?? 'N/A'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String title, String value) {
    return Container(
      width: 110,
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      decoration: ShapeDecoration(
        color: const Color(0xFFEFEFEF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6F6F6F),
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 