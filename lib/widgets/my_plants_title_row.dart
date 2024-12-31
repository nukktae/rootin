import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/filter_modal.dart';

class MyPlantsTitleRow extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onFilter;

  const MyPlantsTitleRow({
    super.key,
    required this.onRefresh,
    required this.onFilter,
  });

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModal(
        selectedStatus: 'All Status',  // You might want to pass these as parameters
        selectedLocation: 'All Locations',
        selectedRoom: 'All Rooms',
        onApply: (status, location, room) {
          // Handle the filter application
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Plants',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () => _showFilterModal(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: ShapeDecoration(
                color: const Color(0xFFEEEEEE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/filter_icon.svg',
                  width: 16,
                  height: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}