import 'package:flutter/material.dart';

class AppTheme {
  // 색상 정의
  static const Color primaryColor = Color(0xFF06C1C7);
  static const Color secondaryColor = Color(0xFF9BE6E9);
  static const Color accentColor = Color(0xFFFF004F);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray600 = Color(0xFF757575);

  // 텍스트 스타일 정의
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: black,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: black,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: black,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: black,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: black,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: gray600,
  );

  // 테마 정의
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: gray100,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: gray100,
        onPrimary: white,
        onSecondary: black,
      ),
      textTheme: const TextTheme(
        displayLarge: heading1,
        displayMedium: heading2,
        displaySmall: heading3,
        bodyLarge: body1,
        bodyMedium: body2,
        bodySmall: caption,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: white, backgroundColor: black, // 버튼 텍스트 색상 유지
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(double.infinity, 50), // 버튼의 전체 너비 사용
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: black, // 버튼 텍스트 색상
          side: const BorderSide(color: black), // 버튼 테두리 색상
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(double.infinity, 50), // 버튼의 전체 너비 사용
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: gray600, // 버튼 텍스트 색상
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: gray200,
        disabledColor: gray300,
        selectedColor: gray200, // 클릭 시 색상 변경 없음
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: black,
        ),
        brightness: Brightness.light,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        fillColor: black, // 선택된 버튼 배경 색상
        selectedColor: white, // 선택된 버튼 텍스트 색상
        color: black, // 기본 버튼 텍스트 색상
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        borderRadius: BorderRadius.circular(20), // 버튼 모서리 둥글기 설정
        constraints: const BoxConstraints(minHeight: 40, minWidth: 100), // 버튼 최소 크기 설정
      ),
    );
  }
}