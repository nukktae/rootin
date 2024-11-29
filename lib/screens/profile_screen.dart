import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/app_guide_screen.dart';

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

  @override
  Widget build(BuildContext context) {
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
                        title: 'App Guide',
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
                        title: 'Shop Sensor',
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
                  title: 'Sensor Settings',
                  icon: SvgPicture.asset('assets/icons/sensor_icon.svg'),
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: 'Notifications',
                  icon: SvgPicture.asset('assets/icons/notification_icon.svg'),
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: 'Help',
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: 'Terms of Service',
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                if (icon != null) ...[
                  icon,
                  const SizedBox(width: 10),
                ],
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
                SvgPicture.asset(
                  'assets/icons/arrow_right.svg',
                  width: 20,
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
