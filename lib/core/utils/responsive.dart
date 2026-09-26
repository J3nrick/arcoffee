import 'package:flutter/cupertino.dart';

/// Responsive design utility for Apple HIG multi-device layout (macOS, iPad, iPhone).
class Responsive {
  static const double mobileBreakpoint = 640;
  static const double tabletBreakpoint = 960;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < tabletBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  static int getGridColumnCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 580) return 1;
    if (width < 880) return 2;
    if (width < 1180) return 3;
    return 3;
  }

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 640) return 18.0;
    if (width < 960) return 28.0;
    return 40.0;
  }
}
