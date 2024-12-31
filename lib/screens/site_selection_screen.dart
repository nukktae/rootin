import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/app_localizations.dart';
import './room_selection_screen.dart';

class SiteSelectionScreen extends StatefulWidget {
  final String id;
  final String name;
  final String? subname;
  final String imageUrl;

  const SiteSelectionScreen({
    super.key,
    required this.id,
    required this.name,
    this.subname,
    required this.imageUrl,
  });

  @override
  State<SiteSelectionScreen> createState() => _SiteSelectionScreenState();
}

class _SiteSelectionScreenState extends State<SiteSelectionScreen> {
  int? selectedIndex;
  final List<Map<String, dynamic>> sites = [
    {'name': 'Living Room', 'siteName': 'Living Room', 'id': 1},
    {'name': 'Kitchen', 'siteName': 'Kitchen', 'id': 2},
    {'name': 'Bathroom', 'siteName': 'Bathroom', 'id': 3},
    {'name': 'Office', 'siteName': 'Office', 'id': 4},
    {'name': 'Bedroom', 'siteName': 'Bedroom', 'id': 5},
  ];

  bool get isContinueEnabled => selectedIndex != null;

  void onSelectSite(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void showAddSiteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Location'),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _navigateToRoomSelection() {
    if (selectedIndex != null) {
      final selectedSite = sites[selectedIndex!];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomSelectionScreen(
            site: selectedSite['siteName'],
            id: widget.id,
            name: widget.name,
            subname: widget.subname ?? '',
            imageUrl: widget.imageUrl,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Back button
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xffE7E7E7),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/arrow.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                AppLocalizations.of(context).chooseSite,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                  letterSpacing: -0.22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).selectSiteOrCustom,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xff6F6F6F),
                ),
              ),
              const SizedBox(height: 32),
              // Grid remains the same, just update the text for "Add your own"
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: sites.length + 1, // Add space for "+ Add your own"
                  itemBuilder: (context, index) {
                    if (index == sites.length) {
                      return Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xFFE3E3E3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          onTap: showAddSiteDialog,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).addYourOwn,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final site = sites[index];
                    final isSelected = selectedIndex == index;

                    return Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: isSelected ? 2.40 : 1,
                            color: isSelected ? Colors.black : const Color(0xFFE3E3E3),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: InkWell(
                        onTap: () => onSelectSite(index),
                        child: Center(
                          child: Text(
                            site['siteName'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Continue button
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isContinueEnabled ? _navigateToRoomSelection : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}