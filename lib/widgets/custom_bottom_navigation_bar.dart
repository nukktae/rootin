import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          print('Navigation tapped: $index');
          widget.onTap(index);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color(0xFF8E8E8E),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: [
          _buildNavItem('nav_home', 'Home', 0),
          _buildNavItem('watering_nav', 'Watering', 1),
          _buildNavItem('nav_profile', 'Profile', 2),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconName, String label, int index) {
    final isSelected = widget.currentIndex == index;
    String iconPath;
    
    switch (iconName) {
      case 'nav_home':
        iconPath = isSelected
            ? 'assets/icons/nav_home_active.svg'
            : 'assets/icons/nav_home_default.svg';
        break;
      case 'watering_nav':
        iconPath = isSelected
            ? 'assets/icons/watering_nav_active.svg'
            : 'assets/icons/watering_nav.svg';
        break;
      default:  // for profile
        iconPath = isSelected
            ? 'assets/icons/nav_profile_active.svg'
            : 'assets/icons/nav_profile_default.svg';
    }

    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
      ),
      label: label,
    );
  }
}
