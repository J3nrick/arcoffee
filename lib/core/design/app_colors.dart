import 'package:flutter/cupertino.dart';

/// Centralized Color System for Arcoffee ("Court-side coffee culture").
/// Palette grounded in Deep Blue + Warm Cream with restrained Arcoffee Orange accents.
abstract class AppColors {
  // Brand Foundation
  static const Color deepBlue = Color(0xFF0B1F33);
  static const Color warmCream = Color(0xFFF6F1E7);
  static const Color accentOrange = Color(0xFFF36B21);
  static const Color softSand = Color(0xFFE8DDCC);
  static const Color mutedBlue = Color(0xFF66798B);
  static const Color darkNight = Color(0xFF07111D);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Surface Elevations (Day Court)
  static const Color surfaceDayL1 = Color(0xFFF6F1E7); // Canvas
  static const Color surfaceDayL2 = Color(0xFFFFFFFF); // Solid Card
  static const Color surfaceDayL3 = Color(0xFFEFE8DA); // Subtle Surface
  static const Color glassDay = Color(0xD1FFFFFF); // Floating Glass

  // Surface Elevations (Midnight Court)
  static const Color surfaceNightL1 = Color(0xFF07111D); // Canvas
  static const Color surfaceNightL2 = Color(0xFF0E1A26); // Solid Card
  static const Color surfaceNightL3 = Color(0xFF142434); // Subtle Surface
  static const Color glassNight = Color(0xCC0B1824); // Floating Glass

  // Semantic Typography (Day Court)
  static const Color textPrimaryDay = Color(0xFF0B1F33);
  static const Color textSecondaryDay = Color(0xFF53677A);
  static const Color textTertiaryDay = Color(0xFF7A8D9E);

  // Semantic Typography (Midnight Court)
  static const Color textPrimaryNight = Color(0xFFF6F1E7);
  static const Color textSecondaryNight = Color(0xFF8FA2B5);
  static const Color textTertiaryNight = Color(0xFF66798B);

  // Accent & Status
  static const Color courtLineDay = Color(0x1F0B1F33);
  static const Color courtLineNight = Color(0x228FA2B5);
  static const Color statusOpen = Color(0xFF2E7D32);
  static const Color statusClosed = Color(0xFFC62828);
}
