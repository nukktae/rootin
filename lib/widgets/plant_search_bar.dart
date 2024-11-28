// File: add_search_bar.dart
import 'package:flutter/material.dart';

// Define a reusable widget for the search bar.
class PlantSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCameraPressed;

  const PlantSearchBar({
    super.key,
    required this.controller,
    required this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Which one to add?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: onCameraPressed,
          ),
        ],
      ),
    );
  }
}