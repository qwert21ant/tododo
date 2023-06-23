import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color separatorSupport = Color(0x33000000);
  static const Color overlaySupport = Color(0x0F000000);

  static const Color labelPrimary = Color(0xFF000000);
  static const Color labelSecondary = Color(0x99000000);
  static const Color labelTertiary = Color(0x4D000000);
  static const Color labelDisable = Color(0x26000000);

  static const Color red = Color(0xFFFF3B30);
  static const Color green = Color(0xFF34C759);
  static const Color blue = Color(0xFF007AFF);
  static const Color gray = Color(0xFF8E8E93);
  static const Color grayLight = Color(0xFFD1D1D6);
  static const Color white = Color(0xFFFFFFFF);

  static const Color backPrimary = Color(0xFFF7F6F2);
  static const Color backSecondary = Color(0xFFFFFFFF);
  static const Color backElevated = Color(0xFFFFFFFF);

  static const TextStyle titleLarge = TextStyle(
    color: Colors.black,
    fontFamily: 'Roboto',
    fontSize: 32,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle body = TextStyle(
    color: labelPrimary,
    fontFamily: 'Roboto',
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w400,
  );
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppTheme.backPrimary,
  appBarTheme: const AppBarTheme(backgroundColor: AppTheme.backPrimary),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);

// Dark colors
// Color(0x33FFFFFF),
// Color(0x52000000),
// Color(0xFFFFFFFF),
// Color(0x99FFFFFF),
// Color(0x66FFFFFF),
// Color(0x26FFFFFF),
// Color(0xFFFF453A),
// Color(0xFF32D74B),
// Color(0xFF0A84FF),
// Color(0xFF8E8E93),
// Color(0xFF48484A),
// Color(0xFFFFFFFF),
// Color(0xFF161618),
// Color(0xFF252528),
// Color(0xFF3C3C3F)
