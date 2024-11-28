import 'package:flutter/material.dart';
import '../models/plant.dart';
import 'chatbot_banner.dart';

class CareTipsSection extends StatelessWidget {
  final Plant? plant;
  final List<String> careTips;

  const CareTipsSection({
    super.key,
    this.plant,
    required this.careTips,
  });

  Map<String, String> get formattedTipsMap {
    return {
      'Difficulty': plant?.infoDifficulty ?? 'Unknown',
      'Watering': plant?.infoWatering ?? 'Unknown',
      'Light': plant?.infoLight ?? 'Unknown',
      'Soil Type': plant?.infoSoilType ?? 'Unknown',
      'Repotting': plant?.infoRepotting ?? 'Unknown',
      'Toxicity': plant?.infoToxicity ?? 'Unknown',
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.15,
            ),
            child: ChatbotBanner(
              plant: plant,
            ),
          ),
          const SizedBox(height: 16),
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
                  _buildTipItem('Difficulty', formattedTipsMap['Difficulty']!),
                  _buildTipItem('Watering', formattedTipsMap['Watering']!),
                  _buildTipItem('Light', formattedTipsMap['Light']!),
                  _buildTipItem('Soil Type', formattedTipsMap['Soil Type']!),
                  _buildTipItem('Repotting', formattedTipsMap['Repotting']!),
                  _buildTipItem('Toxicity', formattedTipsMap['Toxicity']!),
                ],
              ),
            ),
          ),
        ],
      ),
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
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
