// File: add_search_bar.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../screens/camera_capture_screen.dart';

// Define a reusable widget for the search bar.
class PlantSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const PlantSearchBar({
    super.key,
    required this.onSearch,
  });

  @override
  State<PlantSearchBar> createState() => _PlantSearchBarState();
}

class _PlantSearchBarState extends State<PlantSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearch,
                decoration: InputDecoration(
                  hintText: 'Which one to add?',
                  hintStyle: const TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF6F6F6F),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          widget.onSearch('');
                        },
                      )
                    : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
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
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}