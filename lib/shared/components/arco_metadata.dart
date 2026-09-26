import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';

/// Scoreboard & Receipt Metadata treatments for Arcoffee brand personality.
class ArcoScoreboardMetadata extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const ArcoScoreboardMetadata({
    super.key,
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.accentOrange.withOpacity(0.12)
            : (isDark ? const Color(0x22FFFFFF) : AppColors.deepBlue.withOpacity(0.04)),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isHighlight
              ? AppColors.accentOrange.withOpacity(0.4)
              : (isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withOpacity(0.1)),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${label.toUpperCase()}: ",
            style: AppTypography.scoreboard.copyWith(
              fontSize: 11,
              color: isDark ? AppColors.textSecondaryNight : AppColors.mutedBlue,
            ),
          ),
          Text(
            value,
            style: AppTypography.scoreboard.copyWith(
              fontSize: 12,
              color: isHighlight
                  ? AppColors.accentOrange
                  : (isDark ? AppColors.textPrimaryNight : AppColors.deepBlue),
            ),
          ),
        ],
      ),
    );
  }
}

/// Receipt details item (monospaced price/metadata)
class ArcoReceiptText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const ArcoReceiptText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? AppTypography.receipt).copyWith(
        fontFamily: 'Courier',
      ),
    );
  }
}
