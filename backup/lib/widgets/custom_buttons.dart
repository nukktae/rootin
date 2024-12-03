import 'package:flutter/material.dart';
import 'package:fuckyou/themes/app_theme.dart';

class CustomWidgets {
  // Elevated Button Widget
  static Widget customElevatedButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: AppTheme.white,
        backgroundColor: AppTheme.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: AppTheme.body1.copyWith(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(label),
    );
  }

  // Outlined Button Widget
  static Widget customOutlinedButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.black,
        side: const BorderSide(color: AppTheme.black),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: AppTheme.body1.copyWith(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(label),
    );
  }

  // Text Button Widget
  static Widget customTextButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.gray600,
        textStyle: AppTheme.body2,
      ),
      child: Text(label),
    );
  }

  // Toggle Button Widget
  static Widget customToggleButton({
    required List<String> labels,
    required List<bool> isSelected,
    required Function(int) onPressed,
  }) {
    return ToggleButtons(
      isSelected: isSelected,
      onPressed: onPressed,
      fillColor: AppTheme.black,
      selectedColor: AppTheme.white,
      color: AppTheme.black,
      textStyle: AppTheme.body2.copyWith(fontWeight: FontWeight.w500),
      borderRadius: BorderRadius.circular(20),
      constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
      children: labels
          .map((label) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(label),
              ))
          .toList(),
    );
  }
}

// Example usage:
// CustomWidgets.customElevatedButton(
//   label: 'Care Tips',
//   onPressed: () {
//     // Define action here
//   },
// );