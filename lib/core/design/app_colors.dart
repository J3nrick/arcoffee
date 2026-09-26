import 'package:flutter/cupertino.dart';

/// Centralized Color System for Arcoffee ("Court-side coffee culture").
/// Palette grounded in Deep Blue + Warm Cream with restrained Arcoffee Orange accents.
abstract class AppColors {
  // Brand Foundation
  static const Color deepBlue = Color(0xFF0B1B2B);
  static const Color warmCream = Color(0xFFFBF7EB);
  static const Color accentOrange = Color(0xFFF36622);
  static const Color softSand = Color(0xFFEDE4D4);
  static const Color mutedBlue = Color(0xFF5E7387);
  static const Color darkNight = Color(0xFF08111B);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Surface Elevations (Day Court)
  static const Color surfaceDayL1 = Color(0xFFFBF7EB); // Canvas: Warm Linen Cream
  static const Color surfaceDayL2 = Color(0xFFFFFFFF); // Elevated Solid Card
  static const Color surfaceDayL3 = Color(0xFFF2ECE0); // Subtle Secondary Surface
  static const Color glassDay = Color(0xEBFAF6EC);    // Floating Glass Surface

  // Surface Elevations (Midnight Court)
  static const Color surfaceNightL1 = Color(0xFF08111B); // Canvas: Deep Nocturnal Arena
  static const Color surfaceNightL2 = Color(0xFF0F1E2E); // Elevated Solid Card
  static const Color surfaceNightL3 = Color(0xFF16283C); // Subtle Secondary Surface
  static const Color glassNight = Color(0xD90A1522);    // Floating Glass Surface

  // Semantic Typography (Day Court)
  static const Color textPrimaryDay = Color(0xFF0B1B2B);
  static const Color textSecondaryDay = Color(0xFF4A5D70);
  static const Color textTertiaryDay = Color(0xFF758899);

  // Semantic Typography (Midnight Court)
  static const Color textPrimaryNight = Color(0xFFFBF7EB);
  static const Color textSecondaryNight = Color(0xFF90A4B8);
  static const Color textTertiaryNight = Color(0xFF6B8094);

  // Product Category Accents
  static const Color cremaGold = Color(0xFFD49B42);
  static const Color matchaGreen = Color(0xFF3E7A53);
  static const Color sodaBlue = Color(0xFF2D80B8);
  static const Color miloChocolate = Color(0xFF6A4023);

  // Accent & Status
  static const Color courtLineDay = Color(0x280B1B2B);
  static const Color courtLineNight = Color(0x3890A4B8);
  static const Color statusOpen = Color(0xFF2E7D32);
  static const Color statusClosed = Color(0xFFC62828);
}
