import 'package:flutter/material.dart';
import '../widgets/chatbot_banner.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class WaterloggedInstructionsScreen extends StatelessWidget {
  const WaterloggedInstructionsScreen({super.key});

  Widget _buildLanguageSwitcher() {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return GestureDetector(
          onTap: () {
            final newLocale = languageProvider.currentLocale.languageCode == 'en' 
              ? const Locale('ko') 
              : const Locale('en');
            languageProvider.changeLanguage(newLocale);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffE7E7E7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              languageProvider.currentLocale.languageCode.toUpperCase(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and language switcher
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFEEEEEE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    _buildLanguageSwitcher(),
                  ],
                ),
              ),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  localizations.waterLogged,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  localizations.waterLoggedDesc,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Instructions title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  localizations.instructions,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Instructions list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildInstructionItem(context, 1, localizations.checkDrainageHole, 
                      localizations.drainageHoleDesc),
                    _buildInstructionItem(context, 2, localizations.emptyDripTray,
                      localizations.dripTrayDesc),
                    _buildInstructionItem(context, 3, localizations.tryRepotting,
                      localizations.repottingDesc),
                    _buildInstructionItem(context, 4, localizations.checkSensor,
                      localizations.sensorDesc,
                      isWarning: true),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // AI chat suggestion text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  localizations.cantFindReason,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Chatbot banner
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ChatbotBanner(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(BuildContext context, int number, String title, String description, {bool isWarning = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        backgroundColor: isWarning ? const Color(0xFFFFEBEB) : const Color(0xFFF5F5F5),
        collapsedBackgroundColor: isWarning ? const Color(0xFFFFEBEB) : const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isWarning ? Colors.red : Colors.black,
          ),
          child: isWarning 
            ? const Icon(Icons.warning, color: Colors.white, size: 16)
            : Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6F6F6F),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 