// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

import 'app_typography.dart';

class AppColors {
  AppColors._(); // Prevents instantiation

  // ==========================================
  // BRAND COLOR PALETTE (Cyber Obsidian & Violet)
  // ==========================================
  
  // Primary Interactive Accent
  static const Color primary = Color(0xFF7C4DFF);       // Electric Violet
  static const Color primaryLight = Color(0xFFB47CFF);  // Soft Violet Glow
  static const Color primaryDark = Color(0xFF3F1DCB);   // Deep Indigo Base

  // Secondary Accents (Success, Warnings, Badges)
  static const Color accent = Color(0xFF00E5FF);        // Neon Cyan (Great for special tags)
  static const Color priceGreen = Color(0xFF00E676);    // Crisp Transaction Green
  static const Color warningAmber = Color(0xFFFFC400);  // Gold Star Ratings / Stock Alerts

  // Neutral Theme Foundation (Light Mode Surface Variations)
  static const Color backgroundLight = Color(0xFFF8F9FA); // Ultra Clean Chalk
  static const Color surfaceLight = Color(0xFFFFFFFF);    // Pure White Card Canvas
  static const Color textMainLight = Color(0xFF121212);   // Jet Black Typography
  static const Color textMutedLight = Color(0xFF6C757D);  // Slate Gray Subtitles

  // Neutral Theme Foundation (Dark Mode / Glassmorphic Substrates)
  static const Color backgroundDark = Color(0xFF0F0F11);  // Cyber Obsidian Base
  static const Color surfaceDark = Color(0xFF1E1E24);     // Deep Ash Card Canvas
  static const Color textMainDark = Color(0xFFF5F5F7);    // Ice White Typography
  static const Color textMutedDark = Color(0xFF9EA3AE);   // Muted Charcoal Text

  // Structural Utilities
  static const Color borderLight = Color(0xFFE5E5EA);
  static const Color borderDark = Color(0xFF2C2C35);
  static const Color error = Color(0xFFFF3333);

  // ==========================================
  // MATERIAL THEME GENERATION WRAPPERS
  // ==========================================
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: surfaceLight,
        error: error,
      ),
      scaffoldBackgroundColor: backgroundLight,
      cardColor: surfaceLight,
      dividerColor: borderLight,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: textMainLight,
        displayColor: textMainLight,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: const TextStyle(color: textMutedLight),
        prefixIconColor: textMutedLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surfaceDark,
        error: error,
      ),
      scaffoldBackgroundColor: backgroundDark,
      cardColor: surfaceDark,
      dividerColor: borderDark,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: textMainDark,
        displayColor: textMainDark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: const TextStyle(color: textMutedDark),
        prefixIconColor: textMutedDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
