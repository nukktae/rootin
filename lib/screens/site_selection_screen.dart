import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'room_selection_screen.dart';

class SiteSelectionScreen extends StatefulWidget {
  final String id; // Plant ID
  final String name; // Plant nickname
  final String subname; // Plant common name
  final String imageUrl; // Plant image URL

  const SiteSelectionScreen({
    super.key,
    required this.id,
    required this.name,
    required this.subname,
    required this.imageUrl,
  });

  @override
  _SiteSelectionScreenState createState() => _SiteSelectionScreenState();
}

class _SiteSelectionScreenState extends State<SiteSelectionScreen> {
  List<Map<String, dynamic>> sites = [];
  int? selectedIndex;
  bool isContinueEnabled = false;

  @override
  void initState() {
    super.initState();
    getSites();
  }

  /// Fetches sites from `/v1/categories`
  Future<void> getSites() async {
    final String? fcmToken = dotenv.env['FCM_TOKEN']; // Load FCM token dynamically
    if (fcmToken == null || fcmToken.isEmpty) {
      print('Error: FCM Token is missing in .env file');
      return;
    }

    final url = Uri.parse('https://api.rootin.me/v1/categories');
    try {
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $fcmToken', // Use FCM token for authorization
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        final List<Map<String, dynamic>> parsedSites = data.map<Map<String, dynamic>>((item) {
          return {
            'categoryId': item['id'],
            'siteName': item['name'],
          };
        }).toList();

        setState(() {
          sites = parsedSites; // Update sites list
        });
      } else {
        print('Failed to load sites. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching sites: $e');
    }
  }

  /// Adds a new site using `/v1/categories`
  Future<void> addNewSite(String siteName) async {
    if (siteName.isEmpty) {
      print('Site name cannot be empty.');
      return;
    }

    final String? fcmToken = dotenv.env['FCM_TOKEN'];
    if (fcmToken == null || fcmToken.isEmpty) {
      print('Error: FCM Token is missing in .env file');
      return;
    }

    final url = Uri.parse('https://api.rootin.me/v1/categories');
    try {
      final response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $fcmToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'name': siteName}),
      );

      if (response.statusCode == 200) {
        print('New site added: $siteName');
        await getSites(); // Refresh site list
      } else {
        print('Failed to add site. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while adding site: $e');
    }
  }

  /// Handles site selection
  void onSelectSite(int index) {
    setState(() {
      selectedIndex = index;
      isContinueEnabled = true;
    });
  }

  /// Opens dialog to add a custom site
  Future<void> showAddSiteDialog() async {
    final siteName = await showDialog<String>(
      context: context,
      builder: (context) {
        String input = '';
        return AlertDialog(
          backgroundColor: Colors.white, // Ensure dialog has white background
          title: const Text('Add New Site'),
          content: TextField(
            onChanged: (value) => input = value,
            decoration: const InputDecoration(
              hintText: 'Enter site name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, input),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (siteName != null && siteName.isNotEmpty) {
      await addNewSite(siteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // Reduced from 55.0 to 20.0

              // Back Button with Circular Background
              Padding(
                padding: const EdgeInsets.only(top: 8.0), // Reduced from 20.0 to 8.0
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFE7E7E7),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/arrow.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Reduced from 24

              // Title and Subtitle
              const Text(
                'Choose Site of the plant',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.black,
                  letterSpacing: -0.22,
                ),
              ),
              const SizedBox(height: 8), // Reduced spacing
              const Text(
                'Select a site or add a custom option.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xff6F6F6F),
                ),
              ),
              const SizedBox(height: 16), // Reduced spacing before grid

              // Site Selection Grid
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
                      // Add Custom Site Button
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
                          child: const Center(
                            child: Text(
                              '+ Add your own',
                              style: TextStyle(
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

              // Continue Button
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isContinueEnabled
                        ? () {
                            final selectedSite = sites[selectedIndex!];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoomSelectionScreen(
                                  site: selectedSite['siteName'],
                                  id: widget.id,
                                  name: widget.name,
                                  subname: widget.subname,
                                  imageUrl: widget.imageUrl,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isContinueEnabled ? Colors.black : Colors.grey[300],
                      foregroundColor: Colors.white,
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
