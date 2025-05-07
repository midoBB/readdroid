import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grayLight = Color(0xFFFFFFFF);
  static const Color grayDark = Color(0xFF000000);
  static const Color primaryLight =
      Color(0xFF0DA6C9); // --color-blue-600 (base)
  static const Color primaryLightHover =
      Color(0xFF0CABCF); // Approx --color-blue-700
  static const Color btnDefaultLight =
      Color(0xFF968273); // Approx --color-gray-700
  static const Color btnDefaultHoverLight = Color(0xFF7A6859); // Darker gray
  static const Color btnDangerLight = Color(0xFFEF4444); // --color-red-600

  // Dark theme colors
  static const Color primaryDark =
      Color(0xFF0CABCF); // --color-blue-600 for dark
  static const Color primaryDarkHover =
      Color(0xFF0A9BBF); // Approx lighter shade
  static const Color btnDefaultDark =
      Color(0xFF6A7E84); // Approx --color-gray-400
  static const Color btnDefaultHoverDark = Color(0xFF8A9CA1); // Lighter gray
  static const Color btnDangerDark = Color(0xFFEF4444); // --color-red-400

  // ThemeData for light and dark modes
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: Color(0xFFF5F0ED), // Approx --color-gray-50
    textTheme: TextTheme(
        bodyMedium: TextStyle(color: grayDark),
        bodyLarge: TextStyle(color: grayDark),
        bodySmall: TextStyle(color: grayDark)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: btnDefaultLight,
        foregroundColor: white,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: Color(0xFF161A1B), // Approx --color-gray-50 dark
    textTheme: TextTheme(
        bodySmall: TextStyle(color: grayLight),
        bodyLarge: TextStyle(color: grayLight),
        bodyMedium: TextStyle(color: grayLight)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: btnDefaultDark,
        foregroundColor: white,
      ),
    ),
  );
}
