// File: add_search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/camera_capture_screen.dart';
import '../l10n/app_localizations.dart';

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
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearch,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).whichOneToAdd,
                  hintStyle: const TextStyle(
                    color: Color(0xFF6F6F6F),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    letterSpacing: -0.16,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(13),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF6F6F6F),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
              width: 72,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              decoration: ShapeDecoration(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: SvgPicture.asset(
                'assets/icons/camera.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}