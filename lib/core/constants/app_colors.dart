import 'package:flutter/cupertino.dart';

/// App Color Palette tailored for Arcoffee under Apple Human Interface Guidelines (HIG).
/// Brand: Deep Blue (Primary), Bright Orange (Accent), Cream/Off-White (Canvas).
abstract class AppColors {
  // Brand Foundation
  static const Color primaryBlue = Color(0xFF0B1B2B);
  static const Color deepNavy = Color(0xFF08111B);
  static const Color accentOrange = Color(0xFFF36622);
  static const Color courtOrange = Color(0xFFF36622);
  static const Color creamBackground = Color(0xFFFBF7EB);
  static const Color warmCreamCard = Color(0xFFFFFFFF);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color softSand = Color(0xFFEDE4D4);

  // Subtle Tints & Category Shades
  static const Color matchaGreen = Color(0xFF3E7A53);
  static const Color matchaLight = Color(0xFFE8F1EA);
  static const Color sodaBlue = Color(0xFF2D80B8);
  static const Color sodaLight = Color(0xFFE5F0F8);
  static const Color warmCoffee = Color(0xFF6A4023);
  static const Color warmCoffeeLight = Color(0xFFF6EFE9);
  static const Color pickleballGreen = Color(0xFF4A7C59);

  // Typography & Content
  static const Color textPrimary = Color(0xFF0B1B2B);
  static const Color textSecondary = Color(0xFF4A5D70);
  static const Color textTertiary = Color(0xFF758899);
  static const Color textInverse = Color(0xFFFBF7EB);

  // Borders & Dividers (Apple HIG Translucent Grays)
  static const Color borderLight = Color(0x1F0B1B2B);
  static const Color borderSubtle = Color(0x0F0B1B2B);
  static const Color borderCard = Color(0x1A0B1B2B);

  // Frosted Glass & Surface Overlays
  static const Color glassFill = Color(0xEBFAF6EC);
  static const Color glassWhite = Color(0xB8FFFFFF);
  static const Color glassDark = Color(0xD90A1522);
  static const Color macosTrafficRed = Color(0xFFFF5F56);
  static const Color macosTrafficYellow = Color(0xFFFFBD2E);
  static const Color macosTrafficGreen = Color(0xFF27C93F);

  // Status & Badges
  static const Color statusOpen = Color(0xFF2E7D32);
  static const Color statusClosed = Color(0xFFC62828);
  static const Color badgeHighlight = Color(0xFFFFEAD9);
}
