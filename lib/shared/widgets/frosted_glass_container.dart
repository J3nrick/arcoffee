import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';

/// Apple HIG Frosted Glass Container with Gaussian blur and subtle specular border.
class FrostedGlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blurSigma;
  final BoxShadow? shadow;

  const FrostedGlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.margin,
    this.blurSigma = 20.0,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.glassWhite;
    final effectiveBorder = borderColor ?? AppColors.borderLight;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow != null
            ? [shadow!]
            : [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: effectiveBg,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: effectiveBorder,
                  width: 1.0,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
