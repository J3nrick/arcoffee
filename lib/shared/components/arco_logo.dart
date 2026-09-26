import 'package:flutter/cupertino.dart';
import '../../core/constants/app_constants.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';

/// Proportional Official ARCOFFEE Brand Logo Component.
/// Displays the iconic arch & "A" mark with pixel-perfect aspect ratio (2.2875:1)
/// and adaptive day/night theme coloring.
class ArcoLogo extends StatelessWidget {
  final double height;
  final bool showText;
  final bool showSlogan;
  final Color? color;
  final VoidCallback? onTap;

  // Native aspect ratio of the official logo mark (366 x 160)
  static const double aspectRatio = 2.2875;

  const ArcoLogo({
    super.key,
    this.height = 32.0,
    this.showText = true,
    this.showSlogan = true,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    // Use dark mode white logo or day mode blue logo unless explicit color is passed
    final assetPath = (color != null && color == AppColors.accentOrange)
        ? 'assets/images/logo_orange.png'
        : (isDark || (color != null && color == AppColors.pureWhite))
            ? 'assets/images/logo_white.png'
            : 'assets/images/logo_blue.png';

    final logoWidth = height * aspectRatio;

    Widget mark = SizedBox(
      height: height,
      width: logoWidth,
      child: Image.asset(
        assetPath,
        height: height,
        width: logoWidth,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        color: (color != null && color != AppColors.pureWhite && color != AppColors.accentOrange)
            ? color
            : null,
      ),
    );

    if (!showText) {
      if (onTap != null) {
        return GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: mark,
          ),
        );
      }
      return mark;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mark,
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ARCOFFEE",
              style: TextStyle(
                fontFamily: AppTypography.displayFont,
                fontFamilyFallback: AppTypography.displayFontFallback,
                fontSize: height * 0.52,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
                height: 1.0,
                color: color ?? (isDark ? AppColors.textPrimaryNight : AppColors.deepBlue),
              ),
            ),
            if (showSlogan) ...[
              const SizedBox(height: 3),
              Text(
                AppConstants.slogan,
                style: AppTypography.scoreboard.copyWith(
                  fontSize: height * 0.28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentOrange,
                  letterSpacing: 0.8,
                  height: 1.0,
                ),
              ),
            ],
          ],
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: content,
        ),
      );
    }

    return content;
  }
}
