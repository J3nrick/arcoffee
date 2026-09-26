import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

/// Apple HIG Typography System mapped for Arcoffee.
/// Matches SF Pro Display & Text optical hierarchy.
abstract class AppTypography {
  static const String displayFont = 'Plus Jakarta Sans';
  static const String bodyFont = 'Inter';
  static const String monoFont = 'JetBrains Mono';

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

  static const TextStyle largeTitle = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    color: AppColors.textPrimary,
    height: 1.15,
  );

  static const TextStyle title1 = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle title2 = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle title3 = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static const TextStyle body = TextStyle(
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFontFallback,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  static const TextStyle callout = TextStyle(
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFontFallback,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle subhead = TextStyle(
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFontFallback,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.15,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle footnote = TextStyle(
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFontFallback,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    color: AppColors.textSecondary,
    height: 1.35,
  );

  static const TextStyle caption1 = TextStyle(
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFontFallback,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.0,
    color: AppColors.textTertiary,
    height: 1.3,
  );

  static const TextStyle caption2 = TextStyle(
    fontFamily: bodyFont,
    fontFamilyFallback: bodyFontFallback,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textTertiary,
    height: 1.25,
  );

  // Slogan & Brand-specific Highlights
  static const TextStyle brandSlogan = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 18,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.accentOrange,
  );

  static const TextStyle priceTag = TextStyle(
    fontFamily: displayFont,
    fontFamilyFallback: displayFontFallback,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    color: AppColors.primaryBlue,
  );
}
