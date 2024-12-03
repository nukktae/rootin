import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterModal extends StatelessWidget {
  final String selectedStatus;
  final String selectedLocation;
  final String selectedRoom;
  final Function(String, String, String) onApply;

  const FilterModal({
    super.key,
    required this.selectedStatus,
    required this.selectedLocation,
    required this.selectedRoom,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    String status = selectedStatus;
    String location = selectedLocation;
    String room = selectedRoom;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filter",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset('assets/icons/close.svg', width: 24, height: 24),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: status,
              items: const [
                DropdownMenuItem(value: 'All Status', child: Text('All Status')),
                DropdownMenuItem(value: 'Ideal', child: Text('Ideal')),
                DropdownMenuItem(value: 'Underwatered', child: Text('Underwatered')),
                DropdownMenuItem(value: 'Overwatered', child: Text('Overwatered')),
                DropdownMenuItem(value: 'Water-logged', child: Text('Water-logged')),
              ],
              onChanged: (value) => status = value ?? 'All Status',
              decoration: const InputDecoration(labelText: "Status"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: location,
              items: const [
                DropdownMenuItem(value: 'All Locations', child: Text('All Locations')),
                DropdownMenuItem(value: 'Livingroom', child: Text('Livingroom')),
                DropdownMenuItem(value: 'Bedroom', child: Text('Bedroom')),
                DropdownMenuItem(value: 'Kitchen', child: Text('Kitchen')),
              ],
              onChanged: (value) => location = value ?? 'All Locations',
              decoration: const InputDecoration(labelText: "Locations"),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: room,
              items: const [
                DropdownMenuItem(value: 'All Rooms', child: Text('All Rooms')),
                DropdownMenuItem(value: 'Office', child: Text('Office')),
                DropdownMenuItem(value: 'Porch', child: Text('Porch')),
              ],
              onChanged: (value) => room = value ?? 'All Rooms',
              decoration: const InputDecoration(labelText: "Rooms"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onApply(status, location, room);
                Navigator.pop(context);
              },
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}
