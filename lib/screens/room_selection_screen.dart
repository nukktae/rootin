import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'confirm_plant_screen.dart';
import '../l10n/app_localizations.dart';

class RoomSelectionScreen extends StatefulWidget {
  final String site;
  final String id;
  final String name;
  final String subname;
  final String imageUrl;

  const RoomSelectionScreen({
    super.key,
    required this.site,
    required this.id,
    required this.name,
    required this.subname,
    required this.imageUrl,
  });

  @override
  State<RoomSelectionScreen> createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends State<RoomSelectionScreen> {
  List<Map<String, dynamic>> rooms = [];
  int? selectedIndex;
  bool isContinueEnabled = false;

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  /// Fetches rooms filtered by the selected site
  Future<void> getRooms() async {
    final String? fcmToken = dotenv.env['FCM_TOKEN']; // Load FCM token dynamically
    if (fcmToken == null || fcmToken.isEmpty) {
      dev.log('Error: FCM Token is missing in .env file');
      return;
    }

    final url = Uri.parse('https://api.rootin.me/v1/categories');
    try {
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $fcmToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        final filteredRooms = <Map<String, dynamic>>[];

        for (var item in data) {
          final name = item['name'];
          if (name.startsWith('${widget.site}/')) {
            filteredRooms.add({
              'roomName': name.split('/')[1],
              'categoryId': item['id'],
            });
          }
        }

        setState(() {
          rooms = filteredRooms;
        });
      } else {
        dev.log('Failed to load rooms. Status code: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('Error occurred while fetching rooms: $e');
    }
  }

  /// Adds a new room under the selected site
  Future<void> addNewRoom(String roomName) async {
    if (roomName.isEmpty) {
      dev.log('Room name cannot be empty.');
      return;
    }

    final String? fcmToken = dotenv.env['FCM_TOKEN'];
    if (fcmToken == null || fcmToken.isEmpty) {
      dev.log('Error: FCM Token is missing in .env file');
      return;
    }

    final url = Uri.parse('https://api.rootin.me/v1/categories');
    final fullName = '${widget.site}/$roomName';

    try {
      final response = await http.put(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $fcmToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'name': fullName}),
      );

      if (response.statusCode == 200) {
        dev.log('New room added: $roomName');
        await getRooms(); // Refresh the room list
      } else {
        dev.log('Failed to add room. Status code: ${response.statusCode}');
      }
    } catch (e) {
      dev.log('Error occurred while adding room: $e');
    }
  }

  /// Handles room selection
  void onSelectRoom(int index) {
    setState(() {
      selectedIndex = index;
      isContinueEnabled = true;
    });
  }

  /// Opens a dialog for adding a new room
  Future<void> showAddRoomDialog() async {
    final roomName = await showDialog<String>(
      context: context,
      builder: (context) {
        String input = '';
        return AlertDialog(
          backgroundColor: Colors.white, // Ensure dialog has white background
          title: const Text('Add a new room'),
          content: TextField(
            onChanged: (value) => input = value,
            decoration: const InputDecoration(
              hintText: 'Enter room name',
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

    if (roomName != null && roomName.isNotEmpty) {
      await addNewRoom(roomName);
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
              // Back Button
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
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
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // "Choose area of the plant" text
              Text(
                AppLocalizations.of(context).chooseArea,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.22,
                ),
              ),

              // Add subtitle text
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).selectRoomOrCustom,
                style: const TextStyle(
                  color: Color(0xFF6F6F6F),
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.28,
                ),
              ),

              const SizedBox(height: 24),

              // Room selection grid
              LayoutBuilder(
                builder: (context, constraints) {
                  const double itemHeight = 70.0;
                  final int itemCount = rooms.length + 1; // Total items including Add Room button
                  final int rowCount = ((itemCount + 1) / 2).ceil();
                  const double spacing = 10.0;
                  
                  final double totalHeight = itemCount <= 2 
                      ? itemHeight  // Single row
                      : itemCount <= 4 
                          ? (itemHeight * 2) + spacing  // Two rows
                          : (itemHeight * 3) + (spacing * 2); // Three rows
                  
                  return SizedBox(
                    height: totalHeight,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 3.0,
                      ),
                      itemCount: rooms.length + 1,
                      itemBuilder: (context, index) {
                        if (index == rooms.length) {
                          // Add Room Button
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
                              onTap: showAddRoomDialog,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    AppLocalizations.of(context).addRoom,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        final room = rooms[index];
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
                            onTap: () => onSelectRoom(index),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  room['roomName'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Location text and site container - wrap in intrinsic height
              IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).location,
                      style: const TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 22,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.22,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: ShapeDecoration(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        widget.site,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Continue button
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isContinueEnabled && selectedIndex != null
                        ? () {
                            final selectedRoom = rooms[selectedIndex!];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConfirmPlantScreen(
                                  id: widget.id,
                                  plantName: widget.name,
                                  roomName: selectedRoom['roomName'],
                                  categoryId: selectedRoom['categoryId'],
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
                    child: Text(
                      AppLocalizations.of(context).continueText,
                      style: const TextStyle(
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
