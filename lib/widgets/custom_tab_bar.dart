import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<Widget> tabs;

  const CustomTabBar({
    super.key, 
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: TabBar(
            controller: controller,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            labelPadding: const EdgeInsets.symmetric(horizontal: 32),
            tabs: tabs,
            labelColor: Colors.black,
            unselectedLabelColor: const Color(0xFF757575),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
      ),
    );
  }
}
