import 'package:flutter/material.dart';
import '../models/plant.dart';
import 'chatbot_banner.dart';
import '../l10n/app_localizations.dart';


class CareTipsSection extends StatelessWidget {
  final Plant? plant;
  final List<String> careTips;

  const CareTipsSection({
    super.key,
    this.plant,
    required this.careTips,
  });

  Map<String, String> _getFormattedTipsMap(BuildContext context) {
    return {
      AppLocalizations.of(context).difficulty: plant?.infoDifficulty ?? AppLocalizations.of(context).unknown,
      AppLocalizations.of(context).watering: plant?.infoWatering ?? AppLocalizations.of(context).unknown,
      AppLocalizations.of(context).light: plant?.infoLight ?? AppLocalizations.of(context).unknown,
      AppLocalizations.of(context).soilType: plant?.infoSoilType ?? AppLocalizations.of(context).unknown,
      AppLocalizations.of(context).repotting: plant?.infoRepotting ?? AppLocalizations.of(context).unknown,
      AppLocalizations.of(context).toxicity: plant?.infoToxicity ?? AppLocalizations.of(context).unknown,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tipsMap = _getFormattedTipsMap(context);

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
          const SizedBox(height: 28),
          Container(
            width: 393,
            height: 8,
            decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppLocalizations.of(context).overallTips,
              style: const TextStyle(
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
                  _buildTipItem(AppLocalizations.of(context).difficulty, tipsMap[AppLocalizations.of(context).difficulty]!),
                  _buildTipItem(AppLocalizations.of(context).watering, tipsMap[AppLocalizations.of(context).watering]!),
                  _buildTipItem(AppLocalizations.of(context).light, tipsMap[AppLocalizations.of(context).light]!),
                  _buildTipItem(AppLocalizations.of(context).soilType, tipsMap[AppLocalizations.of(context).soilType]!),
                  _buildTipItem(AppLocalizations.of(context).repotting, tipsMap[AppLocalizations.of(context).repotting]!),
                  _buildTipItem(AppLocalizations.of(context).toxicity, tipsMap[AppLocalizations.of(context).toxicity]!),
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
