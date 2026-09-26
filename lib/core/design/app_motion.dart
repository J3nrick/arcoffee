import 'package:flutter/cupertino.dart';

/// Centralized Motion System for Arcoffee design system.
/// Communicates state transitions calmly with full support for prefers-reduced-motion.
abstract class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration emphasis = Duration(milliseconds: 400);
  static const Duration hero = Duration(milliseconds: 600);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve heroCurve = Curves.easeInOutCubic;

  /// Check whether user requested reduced motion
  static bool isReducedMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }
}
