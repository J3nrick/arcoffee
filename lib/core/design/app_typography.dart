import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

/// Centralized Typography System for Arcoffee.
/// Provides stark contrast between Display Editorial headers, Scoreboard metadata, and Receipt details.
abstract class AppTypography {
  // Primary Apple-grade Typefaces
  static const String displayFont = 'Plus Jakarta Sans';
  static const String bodyFont = 'Inter';
  static const String monoFont = 'JetBrains Mono';
  static const String scoreboardFont = monoFont;

  // Fallbacks ensuring native Apple SF Pro rendering on iOS/macOS and crisp web fonts on Windows/Web
  static const List<String> displayFontFallback = [
    '-apple-system',
    'BlinkMacSystemFont',
    'SF Pro Display',
    'Plus Jakarta Sans',
    'Inter',
    'system-ui',
    'sans-serif',
  ];

  static const List<String> bodyFontFallback = [
    '-apple-system',
    'BlinkMacSystemFont',
    'SF Pro Text',
    'Inter',
    'Plus Jakarta Sans',
    'system-ui',
    'sans-serif',
  ];

  static const List<String> monoFontFallback = [
    'SF Mono',
    'JetBrains Mono',
    'Menlo',
    'Monaco',
    'Consolas',
    'monospace',
  ];

  // Display XL (Hero Headlines - Muscular, Bold & Clean)
  static const TextStyle displayXL = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 54,
    fontWeight: FontWeight.w900,
    letterSpacing: -2.0,
    height: 1.02,
    color: AppColors.deepBlue,
  );

  // Display (Section Highlights)
  static const TextStyle display = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.4,
    height: 1.08,
    color: AppColors.deepBlue,
  );

  // Heading XL (Card Headlines & Flagships)
  static const TextStyle headingXL = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.9,
    height: 1.15,
    color: AppColors.deepBlue,
  );

  // Heading (Standard Titles)
  static const TextStyle heading = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
    color: AppColors.deepBlue,
  );

  // Heading Small (Compact Card Titles)
  static const TextStyle headingSmall = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.deepBlue,
  );

  // Body Large (Editorial Narratives)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFontFallback,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.35,
    height: 1.48,
    color: AppColors.textSecondaryDay,
  );

  // Body Standard (Fluid Reading Experience)
  static const TextStyle body = TextStyle(
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFontFallback,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    height: 1.45,
    color: AppColors.textSecondaryDay,
  );

  // Body Small (Product Descriptions & Photo Stories)
  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFontFallback,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.15,
    height: 1.4,
    color: AppColors.textSecondaryDay,
  );

  // Eyebrow / Small Caps Badge Label
  static const TextStyle eyebrow = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.4,
    color: AppColors.accentOrange,
  );

  // Scoreboard Metadata (Athletic, Technical Monospaced)
  static const TextStyle scoreboard = TextStyle(
    fontFamily: monoFont,
    fontFamilyFallback: monoFontFallback,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.deepBlue,
  );

  // Receipt Typography (Coordinates & Colophon)
  static const TextStyle receipt = TextStyle(
    fontFamily: monoFont,
    fontFamilyFallback: monoFontFallback,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.mutedBlue,
  );

  // Price Tag (High-Contrast Bold Display)
  static const TextStyle priceTag = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
    color: AppColors.deepBlue,
  );
}
