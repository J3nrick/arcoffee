import 'package:flutter/cupertino.dart';

/// Supported device classifications according to Apple HIG viewport standards.
enum AppleDeviceType {
  mobile, // iOS iPhone (< 768px)
  tablet, // iPadOS Tablet (768px - 1080px)
  desktop, // macOS Desktop (> 1080px)
}

/// Sizing and layout information provided to adaptive builder callbacks.
class SizingInformation {
  final AppleDeviceType deviceType;
  final Size screenSize;
  final BoxConstraints localConstraints;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const SizingInformation({
    required this.deviceType,
    required this.screenSize,
    required this.localConstraints,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  /// Dynamic grid column count based on available width
  int get gridColumns {
    final width = localConstraints.maxWidth;
    if (width < 680) return 1;
    if (width < 980) return 2;
    if (width < 1280) return 3;
    return 4;
  }

  /// Adaptive horizontal padding
  double get horizontalPadding {
    if (isMobile) return 16.0;
    if (isTablet) return 28.0;
    return 40.0;
  }
}

/// Adaptive Layout Builder checking both MediaQuery and local constraints
/// to deliver genuine iOS and macOS experiences across screen breakpoints.
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, SizingInformation sizing) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  static AppleDeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 768) return AppleDeviceType.mobile;
    if (width < 1080) return AppleDeviceType.tablet;
    return AppleDeviceType.desktop;
  }

  static bool isMobile(BuildContext context) => getDeviceType(context) == AppleDeviceType.mobile;
  static bool isTablet(BuildContext context) => getDeviceType(context) == AppleDeviceType.tablet;
  static bool isDesktop(BuildContext context) => getDeviceType(context) == AppleDeviceType.desktop;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = constraints.maxWidth < 768
            ? AppleDeviceType.mobile
            : (constraints.maxWidth < 1080 ? AppleDeviceType.tablet : AppleDeviceType.desktop);

        final sizing = SizingInformation(
          deviceType: deviceType,
          screenSize: mediaQuery.size,
          localConstraints: constraints,
          isMobile: deviceType == AppleDeviceType.mobile,
          isTablet: deviceType == AppleDeviceType.tablet,
          isDesktop: deviceType == AppleDeviceType.desktop,
        );

        return builder(context, sizing);
      },
    );
  }
}
