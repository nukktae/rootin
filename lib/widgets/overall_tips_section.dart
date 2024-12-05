import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';

class OverallTipsSection extends StatelessWidget {
  final Map<String, dynamic> careTips;

  const OverallTipsSection({
    super.key,
    required this.careTips,
  });

  String _getLocalizedValue(BuildContext context, String key) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final value = careTips[key] ?? 'N/A';
    
    // Map English API values to localized strings
    switch (value) {
      // Difficulty
      case 'Easy':
        return languageProvider.currentLocale.languageCode == 'ko' ? '쉬움' : 'Easy';
      case 'Moderate':
        return languageProvider.currentLocale.languageCode == 'ko' ? '보통' : 'Moderate';
      case 'Hard':
        return languageProvider.currentLocale.languageCode == 'ko' ? '어려움' : 'Hard';
        
      // Watering
      case '1-2 Weeks':
        return languageProvider.currentLocale.languageCode == 'ko' ? '1-2주' : '1-2 Weeks';
      case '2-3 Weeks':
        return languageProvider.currentLocale.languageCode == 'ko' ? '2-3주' : '2-3 Weeks';
        
      // Light
      case 'Partial Sun':
        return languageProvider.currentLocale.languageCode == 'ko' ? '부분 양지' : 'Partial Sun';
      case 'Full Sun':
        return languageProvider.currentLocale.languageCode == 'ko' ? '전체 양지' : 'Full Sun';
      case 'Low Light':
        return languageProvider.currentLocale.languageCode == 'ko' ? '낮은 광도' : 'Low Light';
        
      // Soil Type
      case 'Well-Drain':
        return languageProvider.currentLocale.languageCode == 'ko' ? '배수 잘되는 흙' : 'Well-Drain';
        
      // Repotting
      case '6-12 Months':
        return languageProvider.currentLocale.languageCode == 'ko' ? '6-12개월' : '6-12 Months';
      case '12-18 Months':
        return languageProvider.currentLocale.languageCode == 'ko' ? '12-18개월' : '12-18 Months';
        
      // Toxicity
      case 'Non-Toxic':
        return languageProvider.currentLocale.languageCode == 'ko' ? '무독성' : 'Non-Toxic';
      case 'Toxic':
        return languageProvider.currentLocale.languageCode == 'ko' ? '독성' : 'Toxic';
        
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            localizations.overallTips,
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
                _buildTipItem(localizations.difficulty, _getLocalizedValue(context, 'Difficulty')),
                _buildTipItem(localizations.watering, _getLocalizedValue(context, 'Watering')),
                _buildTipItem(localizations.light, _getLocalizedValue(context, 'Light')),
                _buildTipItem(localizations.soilType, _getLocalizedValue(context, 'Soil Type')),
                _buildTipItem(localizations.repotting, _getLocalizedValue(context, 'Repotting')),
                _buildTipItem(localizations.toxicity, _getLocalizedValue(context, 'Toxicity')),
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