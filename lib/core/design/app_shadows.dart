import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

/// Centralized Elevation Shadow System for Arcoffee.
abstract class AppShadows {
  static List<BoxShadow> cardShadow(bool isDark) {
    if (isDark) {
      return const [
        BoxShadow(
          color: Color(0x66000000),
          blurRadius: 20,
          offset: Offset(0, 6),
        ),
      ];
    }
    return [
      BoxShadow(
        color: AppColors.deepBlue.withValues(alpha: 0.06),
        blurRadius: 18,
        offset: const Offset(0, 6),
      ),
    ];
  }

  static List<BoxShadow> floatingNavShadow(bool isDark) {
    if (isDark) {
      return const [
        BoxShadow(
          color: Color(0x80000000),
          blurRadius: 28,
          offset: Offset(0, 10),
        ),
      ];
    }
    return [
      BoxShadow(
        color: AppColors.deepBlue.withValues(alpha: 0.08),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ];
  }

  static List<BoxShadow> orangeGlow = [
    BoxShadow(
      color: AppColors.accentOrange.withValues(alpha: 0.35),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];
}
