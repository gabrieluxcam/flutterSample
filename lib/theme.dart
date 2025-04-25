// lib/theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1E88E5);
  static const background = Colors.white;
  static const text = Colors.black;
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.background,
    surface: AppColors.background,
    onSurface: AppColors.text,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.background,
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.grey,
    backgroundColor: AppColors.background,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: AppColors.background,
      backgroundColor: AppColors.primary,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    ),
  ),
  cardTheme: const CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.text),
    bodyMedium: TextStyle(color: AppColors.text),
    titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
  ),
);

final ThemeData appDarkTheme = ThemeData.dark().copyWith(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: const Color(0xFF181A20),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    surface: Color(0xFF23242B),
    onSurface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF23242B),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.grey,
    backgroundColor: Color(0xFF23242B),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.primary,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
    ),
  ),
  cardTheme: const CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
    color: Color(0xFF23242B),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color.fromARGB(255, 77, 70, 70)),
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
);
