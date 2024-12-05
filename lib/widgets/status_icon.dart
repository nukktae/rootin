import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatusIcon extends StatelessWidget {
  final String status;

  const StatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    String iconPath;
    Color backgroundColor;

    String statusToUse = status.toUpperCase();
    if (statusToUse == "NO_SENSOR") {
      statusToUse = "MEASURING";
    }

    switch (statusToUse) {
      case "IDEAL":
        iconPath = 'assets/icons/status_ideal.svg';
        backgroundColor = const Color(0xFF73C2FB);
        break;
      case "WATER_NEEDED":
        iconPath = 'assets/icons/status_underwater.svg';
        backgroundColor = const Color(0xFFD4B500);
        break;
      case "OVERWATER":
        iconPath = 'assets/icons/status_overwater.svg';
        backgroundColor = const Color(0xff24494E);
        break;
      case "WATERLOGGED":
        iconPath = 'assets/icons/status_waterlogged.svg';
        backgroundColor = const Color(0xFF000000);
        break;
      case "MEASURING":
        iconPath = 'assets/icons/status_measuring.svg';
        backgroundColor = const Color(0xFF757575);
        break;
      default:
        iconPath = 'assets/icons/status_measuring.svg';
        backgroundColor = const Color(0xFF757575);
    }

    return Container(
      width: 34,
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: SvgPicture.asset(
        iconPath,
        width: 18,
        height: 18,
      ),
    );
  }
}
