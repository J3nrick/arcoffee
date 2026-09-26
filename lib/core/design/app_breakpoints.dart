import 'package:flutter/cupertino.dart';

/// Centralized Responsive Breakpoints System for Arcoffee.
abstract class AppBreakpoints {
  static const double mobileMax = 600.0;
  static const double tabletMax = 1024.0;
  static const double desktopMax = 1440.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileMax;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobileMax && w < tabletMax;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletMax;

  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < mobileMax) return 16.0;
    if (w < tabletMax) return 32.0;
    return 64.0;
  }
}
