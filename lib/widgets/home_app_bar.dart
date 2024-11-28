import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/camera_capture_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showLogoAndAddIcon;

  const HomeAppBar({super.key, this.showLogoAndAddIcon = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFFFFFF), // Background color
      elevation: 0, // No shadow
      toolbarHeight: 100, // Increase the height of the AppBar
      title: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10), // Additional top padding if needed
          child: Row(
            children: [
              if (showLogoAndAddIcon) ...[
                SvgPicture.asset(
                  'assets/icons/logo.svg',
                  width: 111,
                  height: 28,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CameraCaptureScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(9),
                    child: SvgPicture.asset(
                      'assets/icons/add.svg',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100); // Adjust height
}
