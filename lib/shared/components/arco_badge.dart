import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';

/// Clean, minimal category & status badges for Arcoffee.
class ArcoBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const ArcoBadge({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    final bg = backgroundColor ?? (isDark ? const Color(0x33FFFFFF) : AppColors.deepBlue.withOpacity(0.06));
    final txt = textColor ?? (isDark ? AppColors.textPrimaryNight : AppColors.deepBlue);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: txt),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: AppTypography.eyebrow.copyWith(
              fontSize: 10,
              color: txt,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
