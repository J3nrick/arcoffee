import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';

/// Reusable Brand Sticker Stamps for Arcoffee ("Court-side coffee culture").
/// Adds youthful, social personality without cluttering content.
class ArcoSticker extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double rotation;

  const ArcoSticker({
    super.key,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.rotation = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    final bg = backgroundColor ?? (isDark ? const Color(0xFF16293B) : AppColors.softSand);
    final txt = textColor ?? (isDark ? AppColors.textPrimaryNight : AppColors.deepBlue);

    return Transform.rotate(
      angle: rotation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: txt.withValues(alpha: 0.2),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepBlue.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: txt),
              const SizedBox(width: 4),
            ],
            Text(
              text.toUpperCase(),
              style: AppTypography.eyebrow.copyWith(
                fontSize: 10,
                color: txt,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
