import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

/// Apple HIG capsule badge pill for tags, categories, and court callouts.
class BadgePill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final bool isSmall;

  const BadgePill({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor = AppColors.badgeHighlight,
    this.textColor = AppColors.accentOrange,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8.0 : 12.0,
        vertical: isSmall ? 3.0 : 5.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withValues(alpha: 0.18),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: isSmall ? 11 : 13,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: (isSmall ? AppTypography.caption2 : AppTypography.caption1).copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
