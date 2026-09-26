import 'package:flutter/cupertino.dart';

/// App Color Palette tailored for Arcoffee under Apple Human Interface Guidelines (HIG).
/// Brand: Deep Blue (Primary), Bright Orange (Accent), Cream/Off-White (Canvas).
abstract class AppColors {
  // Brand Foundation
  static const Color primaryBlue = Color(0xFF0F2537);
  static const Color deepNavy = Color(0xFF081520);
  static const Color accentOrange = Color(0xFFFF6600);
  static const Color courtOrange = Color(0xFFFF7A1A);
  static const Color creamBackground = Color(0xFFFAF7F2);
  static const Color warmCreamCard = Color(0xFFF3EFE8);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Subtle Tints & Category Shades
  static const Color matchaGreen = Color(0xFF4A7C59);
  static const Color matchaLight = Color(0xFFE8F1EA);
  static const Color sodaBlue = Color(0xFF2E7BB4);
  static const Color sodaLight = Color(0xFFE5F0F8);
  static const Color warmCoffee = Color(0xFF6B4226);
  static const Color warmCoffeeLight = Color(0xFFF6EFE9);
  static const Color pickleballGreen = Color(0xFF86A873);

  // Typography & Content
  static const Color textPrimary = Color(0xFF0F2537);
  static const Color textSecondary = Color(0xFF5C6F80);
  static const Color textTertiary = Color(0xFF8E9EAC);
  static const Color textInverse = Color(0xFFFAF7F2);

  // Borders & Dividers (Apple HIG Translucent Grays)
  static const Color borderLight = Color(0x180F2537);
  static const Color borderSubtle = Color(0x0D0F2537);
  static const Color borderCard = Color(0x1F0F2537);

  // Frosted Glass & Surface Overlays
  static const Color glassFill = Color(0xCCFAF7F2);
  static const Color glassWhite = Color(0xB8FFFFFF);
  static const Color glassDark = Color(0x800F2537);
  static const Color macosTrafficRed = Color(0xFFFF5F56);
  static const Color macosTrafficYellow = Color(0xFFFFBD2E);
  static const Color macosTrafficGreen = Color(0xFF27C93F);

  // Status & Badges
  static const Color statusOpen = Color(0xFF34C759);
  static const Color statusClosed = Color(0xFFFF3B30);
  static const Color badgeHighlight = Color(0xFFFFEAD9);
}
