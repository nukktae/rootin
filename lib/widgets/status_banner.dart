import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../l10n/app_localizations.dart';

class StatusBanner extends StatelessWidget {
  final String status;
  final VoidCallback onButtonPressed;
  final BuildContext context;

  const StatusBanner({
    super.key,
    required this.status,
    required this.onButtonPressed,
    required this.context,
  });

  Color getBannerColor() {
    String statusToUse = status.toUpperCase();
    if (statusToUse == "NO_SENSOR") {
      statusToUse = "MEASURING";
    }

    switch (statusToUse) {
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
    String statusToUse = status.toUpperCase();
    if (statusToUse == "NO_SENSOR") {
      statusToUse = "MEASURING";
    }

    switch (statusToUse) {
      case "IDEAL":
        return AppLocalizations.of(context).backToIdeal;
      case "WATER_NEEDED":
      case "UNDERWATER":
        return AppLocalizations.of(context).dryingOut;
      case "MEASURING":
        return AppLocalizations.of(context).measuring;
      case "WATERLOGGED":
        return AppLocalizations.of(context).waterloggedIssue;
      case "OVERWATER":
        return AppLocalizations.of(context).overwatered;
      default:
        return AppLocalizations.of(context).measuring;
    }
  }

  String getSubtitle() {
    String statusToUse = status.toUpperCase();
    if (statusToUse == "NO_SENSOR") {
      statusToUse = "MEASURING";
    }

    switch (statusToUse) {
      case "IDEAL":
        return AppLocalizations.of(context).plantLivelyAgain;
      case "WATER_NEEDED":
      case "UNDERWATER":
        return AppLocalizations.of(context).waterToIdeal;
      case "MEASURING":
        return AppLocalizations.of(context).notifyWhenComplete;
      case "WATERLOGGED":
        return AppLocalizations.of(context).insufficientDrainage;
      case "OVERWATER":
        return AppLocalizations.of(context).tooMuchWater;
      default:
        return AppLocalizations.of(context).notifyWhenComplete;
    }
  }

  String getButtonText() {
    String statusToUse = status.toUpperCase();
    if (statusToUse == "NO_SENSOR") {
      statusToUse = "MEASURING";
    }

    switch (statusToUse) {
      case "WATER_NEEDED":
      case "UNDERWATER":
      case "IDEAL":
        return AppLocalizations.of(context).goToWatering;
      case "WATERLOGGED":
      case "OVERWATER":
        return AppLocalizations.of(context).checkInstructions;
      case "MEASURING":
        return AppLocalizations.of(context).learnMore;
      default:
        return AppLocalizations.of(context).learnMore;
    }
  }

  void _navigateToWatering() {
    if (!context.mounted) return;
    
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(initialIndex: 1),
      ),
      (route) => false,
    );
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
              color: status.toUpperCase() == "IDEAL" 
                  ? const Color(0xFFE3F3FE)
                  : (status.toUpperCase() == "WATER_NEEDED" || 
                     status.toUpperCase() == "UNDERWATER")
                      ? const Color(0xFFF6F0CC)
                      : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: TextButton(
              onPressed: () {
                if (status.toUpperCase() == "IDEAL" ||
                    status.toUpperCase() == "WATER_NEEDED" ||
                    status.toUpperCase() == "UNDERWATER") {
                  _navigateToWatering();
                } else {
                  onButtonPressed();
                }
              },
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
