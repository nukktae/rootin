import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'care_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({
    super.key,
    this.initialIndex = 0,  // Default to home tab
  });

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _screens.addAll([
      HomeScreen(setCurrentIndex: setCurrentIndex),
      CareScreen(setCurrentIndex: setCurrentIndex),
      const ProfileScreen(),
    ]);
  }

  void _onTabTapped(int index) {
    setCurrentIndex(index);
  }

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
