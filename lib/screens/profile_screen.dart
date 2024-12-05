import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../screens/app_guide_screen.dart';
import '../screens/notification_settings_screen.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchRootinWebsite(BuildContext context) async {
    final Uri url = Uri.parse('https://www.rootin.me');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open website'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open website'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openPlantDiseaseCamera(BuildContext context) async {
    try {
      // Get available cameras
      final cameras = await availableCameras();
      
      // Navigate to camera screen
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(
                child: Text('Camera feature not available'),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error accessing camera: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not access camera'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isKorean = languageProvider.currentLocale.languageCode == 'ko';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36),
                const Text(
                  'My Page',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.28,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAccessButton(
                        title: AppLocalizations.of(context).appGuide,
                        iconPath: 'assets/icons/guide_icon.svg',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AppGuideScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 17),
                    Expanded(
                      child: _buildQuickAccessButton(
                        title: AppLocalizations.of(context).shopSensor,
                        iconPath: 'assets/icons/shop_icon.svg',
                        onTap: () => _launchRootinWebsite(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  height: 8,
                  color: const Color(0xFFEFEFEF),
                ),
                const SizedBox(height: 24),
                _buildMenuItem(
                  title: AppLocalizations.of(context).sensorSettings,
                  icon: SvgPicture.asset('assets/icons/sensor_icon.svg'),
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: AppLocalizations.of(context).notifications,
                  icon: SvgPicture.asset('assets/icons/notification_icon.svg'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationSettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  title: AppLocalizations.of(context).language,
                  icon: const Icon(
                    Icons.language,
                    size: 24,
                    color: Colors.black,
                  ),
                  trailing: Text(
                    isKorean ? '한국어' : 'English',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(AppLocalizations.of(context).selectLanguage),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('한국어'),
                                leading: Radio<String>(
                                  value: 'ko',
                                  groupValue: languageProvider.currentLocale.languageCode,
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      languageProvider.changeLanguage(Locale(value));
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('English'),
                                leading: Radio<String>(
                                  value: 'en',
                                  groupValue: languageProvider.currentLocale.languageCode,
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      languageProvider.changeLanguage(Locale(value));
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                _buildMenuItem(
                  title: AppLocalizations.of(context).help,
                  icon: const Icon(Icons.help_outline, color: Colors.black),
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: AppLocalizations.of(context).privacyPolicy,
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: AppLocalizations.of(context).termsOfService,
                  onTap: () {},
                ),
                const SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Handle delete account
                    },
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Color(0xFFF83446),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required String title,
    required VoidCallback onTap,
    required String iconPath,
  }) {
    return Container(
      height: 118,
      decoration: ShapeDecoration(
        color: const Color(0xFFEEEEEE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                color: Colors.black,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
    Widget? icon,
    Widget? trailing,
  }) {
    return Container(
      height: 47,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                if (icon != null) 
                  SizedBox(
                    width: 24,  // Fixed width for icon
                    height: 24, // Fixed height for icon
                    child: icon,
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.16,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
