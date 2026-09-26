import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../theme/theme_controller.dart';

/// Decorative Court Line component for Arcoffee.
/// Provides subtle pickleball court geometry, structural intersection points, and corner brackets.
class ArcoCourtLine extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isVertical;
  final bool isDashed;
  final Color? color;

  const ArcoCourtLine({
    super.key,
    this.width,
    this.height,
    this.isVertical = false,
    this.isDashed = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final lineColor = color ?? (isDark ? AppColors.courtLineNight : AppColors.courtLineDay);

    if (isVertical) {
      return Container(
        width: width ?? 1.0,
        height: height ?? double.infinity,
        color: lineColor,
      );
    }

    return Container(
      width: width ?? double.infinity,
      height: height ?? 1.0,
      color: lineColor,
    );
  }
}

/// Structural Corner Bracket inspired by court boundary lines.
class ArcoCornerBracket extends StatelessWidget {
  final Widget child;
  final double size;
  final double strokeWidth;

  const ArcoCornerBracket({
    super.key,
    required this.child,
    this.size = 12.0,
    this.strokeWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final color = isDark ? AppColors.accentOrange.withOpacity(0.4) : AppColors.deepBlue.withOpacity(0.25);

    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: size,
            height: strokeWidth,
            color: color,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: strokeWidth,
            height: size,
            color: color,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: size,
            height: strokeWidth,
            color: color,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: strokeWidth,
            height: size,
            color: color,
          ),
        ),
      ],
    );
  }
}
