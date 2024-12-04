import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'care_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
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
