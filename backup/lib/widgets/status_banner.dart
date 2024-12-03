import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
  final String status;
  final VoidCallback onButtonPressed;

  const StatusBanner({
    super.key,
    required this.status,
    required this.onButtonPressed,
  });

  Color getBannerColor() {
    switch (status.toUpperCase()) {
      case "IDEAL":
        return const Color(0xFF73C2FB);
      case "WATER_NEEDED":
      case "UNDERWATER":
        return const Color(0xFFD3B400);
      case "MEASURING":
        return const Color(0xFF757575);
      case "WATERLOGGED":
        return const Color(0xFF333333);
      case "OVERWATER":
        return const Color(0xFF24494E);
      default:
        return const Color(0xFF757575);
    }
  }

  String getTitle() {
    switch (status.toUpperCase()) {
      case "IDEAL":
        return "Back to Ideal!";
      case "WATER_NEEDED":
      case "UNDERWATER":
        return "Drying Out!";
      case "MEASURING":
        return "Measuring...";
      case "WATERLOGGED":
        return "Water-logged issue!";
      case "OVERWATER":
        return "Overwatered!";
      default:
        return "Status Unknown";
    }
  }

  String getSubtitle() {
    switch (status.toUpperCase()) {
      case "IDEAL":
        return "Nice job! Your plant looks lively again.";
      case "WATER_NEEDED":
      case "UNDERWATER":
        return "Water your plant to bring it back to ideal moisture.";
      case "MEASURING":
        return "Notify you as soon as the measurement is complete!";
      case "WATERLOGGED":
        return "Drainage hasn't been sufficient for the past 3 days.";
      case "OVERWATER":
        return "Your plant has too much water. Let it dry out a bit.";
      default:
        return "No details available.";
    }
  }

  String getButtonText() {
    switch (status.toUpperCase()) {
      case "WATER_NEEDED":
      case "UNDERWATER":
        return "Go to watering";
      case "WATERLOGGED":
      case "OVERWATER":
        return "Check instructions";
      case "IDEAL":
      case "MEASURING":
        return "Learn more";
      default:
        return "Learn more";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 149,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: getBannerColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getTitle(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: -0.20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  getSubtitle(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    letterSpacing: -0.14,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: ShapeDecoration(
              color: (status.toUpperCase() == "WATER_NEEDED" || 
                     status.toUpperCase() == "UNDERWATER")
                  ? const Color(0xFFF6F0CC)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: TextButton(
              onPressed: onButtonPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                getButtonText(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: -0.28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
