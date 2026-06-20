import 'package:flutter/material.dart';

abstract class AppColors {
  // Core Palette Hex Mappings (Vibrant Blue theme)
  static const Color primary = Color(0xFF0000FF);     // Headline / Brand (Pure Blue)
  static const Color secondary = Color(0xFF4D73FF);   // Body / Accent (Vibrant Medium Blue)
  static const Color tertiary = Color(0xFFFF5252);    // Highlights / Badges (Vibrant Red)
  static const Color neutral = Color(0xFF758296);     // Borders / Captions (Gray-Blue)

  // Light Mode Specifics
  static const Color bgLight = Color(0xFFF0F4FF);      // Soft pale blue backdrop
  static const Color surfaceLight = Colors.white;
  static const Color textDark = Color(0xFF0A102D);     // High contrast body for light mode (Dark blue-black)

  // Dark Mode Specifics
  static const Color bgDark = Color(0xFF05081A);       // Deep indigo black
  static const Color surfaceDark = Color(0xFF111633);    // Soft dark indigo surface
  static const Color primaryDarkAccent = Color(0xFF80A0FF); // High-contrast primary for dark components (Vibrant light blue)
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.surfaceLight,
        error: Color(0xFFBA1A1A),
        onPrimary: Colors.white,
        onSecondary: AppColors.textDark,
        onTertiary: Colors.white,
        onSurface: AppColors.textDark,
        surfaceContainerHighest: AppColors.bgLight,
        outline: AppColors.neutral,
      ),
      scaffoldBackgroundColor: AppColors.bgLight,

      // Text Theme matching your Headline/Body spec
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.textDark, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.neutral, fontSize: 14), // fallback body
      ),

      // Widget Themes
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size.fromHeight(48),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neutral),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.neutral.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.neutral),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.secondary, // Swapped to secondary for softer glow on true black
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.surfaceDark,
        error: Color(0xFFFFB4AB),
        onPrimary: AppColors.bgDark,
        onSecondary: AppColors.bgDark,
        onSurface: Colors.white,
        outline: AppColors.neutral,
      ),
      scaffoldBackgroundColor: AppColors.bgDark,

      // Text Theme tailored for dark background readability
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.secondary, fontSize: 16), // Vibrant blue accent pops perfectly here
        bodyMedium: TextStyle(color: Color(0xFFD1DEDE), fontSize: 14),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.bgDark,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondary,
          side: const BorderSide(color: AppColors.secondary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size.fromHeight(48),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neutral),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.neutral.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.secondary, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.secondary),
      ),
    );
  }
}