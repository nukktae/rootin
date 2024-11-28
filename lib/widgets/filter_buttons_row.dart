import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterButtonsRow extends StatelessWidget {
  final Function(String?) onStatusChange;
  final Function(String?) onLocationChange;
  final Function(String?) onRoomChange;

  const FilterButtonsRow({
    super.key,
    required this.onStatusChange,
    required this.onLocationChange,
    required this.onRoomChange,
  });

  Widget _buildDropdownButton({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0), // Smaller padding
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE), // Background color #EEEEEE
        borderRadius: BorderRadius.circular(18),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: onChanged,
        underline: const SizedBox(), // Removes underline
        icon: SvgPicture.asset(
          'assets/icons/arrow_drop_down.svg', // Custom SVG icon
          width: 12,
          height: 12,
        ),
        alignment: Alignment.center, // Center-aligns the text within the button
        style: const TextStyle(
          fontFamily: 'Inter', // Custom font
          fontSize: 14,
          color: Colors.black,
        ),
        dropdownColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildDropdownButton(
          value: 'All status',
          items: ['All status', 'Ideal', 'Underwater', 'Overwater', 'No sensor'],
          onChanged: onStatusChange,
        ),
        const SizedBox(width: 10), // Adjust space between buttons if needed
        _buildDropdownButton(
          value: 'All locations',
          items: ['All locations', 'Office', 'Living Room', 'Bathroom'],
          onChanged: onLocationChange,
        ),
        const SizedBox(width: 10), // Adjust space between buttons if needed
        _buildDropdownButton(
          value: 'All rooms',
          items: ['All rooms', 'Home', 'Work'],
          onChanged: onRoomChange,
        ),
      ],
    );
  }
}
