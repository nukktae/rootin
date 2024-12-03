import 'package:flutter/material.dart';

class CareTabBar extends StatelessWidget {
  final TabController controller;

  const CareTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: 'Today'),
          Tab(text: 'Upcoming'),
        ],
      ),
    );
  }
}
