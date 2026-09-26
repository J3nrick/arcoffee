import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

/// Centralized Typography System for Arcoffee.
/// Provides stark contrast between Display Editorial headers, Scoreboard metadata, and Receipt details.
abstract class AppTypography {
  static const String fontFamily = 'SF Pro Display';

  // Display XL (Hero Headlines)
  static const TextStyle displayXL = TextStyle(
    fontFamily: fontFamily,
    fontSize: 52,
    fontWeight: FontWeight.w900,
    letterSpacing: -1.8,
    height: 1.05,
    color: AppColors.deepBlue,
  );

  // Display (Section Highlights)
  static const TextStyle display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2,
    height: 1.1,
    color: AppColors.deepBlue,
  );

  // Heading XL (Card Headlines)
  static const TextStyle headingXL = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    height: 1.2,
    color: AppColors.deepBlue,
  );

  // Heading (Standard Titles)
  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 1.25,
    color: AppColors.deepBlue,
  );

  // Heading Small
  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.deepBlue,
  );

  // Body Large
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.3,
    height: 1.45,
    color: AppColors.textSecondaryDay,
  );

  // Body Standard
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    height: 1.4,
    color: AppColors.textSecondaryDay,
  );

  // Body Small
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.35,
    color: AppColors.textSecondaryDay,
  );

  // Eyebrow / Category Header
  static const TextStyle eyebrow = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
    color: AppColors.accentOrange,
  );

  // Scoreboard Metadata (Monospaced & Bold)
  static const TextStyle scoreboard = TextStyle(
    fontFamily: 'Courier',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppColors.deepBlue,
  );

  // Receipt Typography (Monospaced Compact)
  static const TextStyle receipt = TextStyle(
    fontFamily: 'Courier',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.mutedBlue,
  );

  // Price Tag
  static const TextStyle priceTag = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.deepBlue,
  );
}
