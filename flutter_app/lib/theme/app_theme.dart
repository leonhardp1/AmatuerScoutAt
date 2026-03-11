import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF0A0A0C);
  static const Color foreground = Color(0xFFF5F5F5);
  static const Color card = Color(0xFF141418);
  static const Color cardTransparent = Color(0xCC141418);
  static const Color primary = Color(0xFF22C55E);
  static const Color primaryForeground = Color(0xFF0A0A0C);
  static const Color secondary = Color(0xFF1A1A1F);
  static const Color muted = Color(0xFF1A1A1F);
  static const Color mutedForeground = Color(0xFFA1A1AA);
  static const Color accent = Color(0xFFEAB308);
  static const Color accentForeground = Color(0xFF0A0A0C);
  static const Color border = Color(0x1AFFFFFF);
  static const Color input = Color(0x0DFFFFFF);
  static const Color sidebar = Color(0xFF0F0F12);
  static const Color sidebarBorder = Color(0x14FFFFFF);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.card,
        onPrimary: AppColors.primaryForeground,
        onSecondary: AppColors.accentForeground,
        onSurface: AppColors.foreground,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor: AppColors.foreground,
        displayColor: AppColors.foreground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
   
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
