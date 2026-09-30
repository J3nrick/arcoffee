import 'package:flutter/cupertino.dart';
import '../../../../core/design/app_colors.dart';
import '../../../../core/design/app_typography.dart';
import '../../../../shared/components/arco_button.dart';
import '../../../../theme/theme_controller.dart';

/// Editorial empty state for the player's Courtside Tray.
/// Delivers confident athletic brand language without generic templates.
class EmptyTrayView extends StatelessWidget {
  final VoidCallback onExploreMenu;

  const EmptyTrayView({
    super.key,
    required this.onExploreMenu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Monospaced Court Metadata
          Text(
            "AR / TRAY  •  0 ITEMS",
            style: AppTypography.scoreboard.copyWith(
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
            ),
          ),
          const SizedBox(height: 16),

          // Primary Editorial Headline
          Text(
            "Your tray is empty. Time to call the next shot.",
            textAlign: TextAlign.center,
            style: AppTypography.heading.copyWith(
              fontSize: 22,
              height: 1.25,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
              color: theme.primaryText,
            ),
          ),
          const SizedBox(height: 10),

          // Confident Athletic Body Copy
          Text(
            "Fuel up with craft espresso, Milo overloads, or sparkling sodas walked directly to your court between rallies.",
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 14,
              height: 1.45,
              color: theme.secondaryText,
            ),
          ),
          const SizedBox(height: 28),

          // Action CTA
          ArcoButton(
            text: "Order to Court →",
            onPressed: onExploreMenu,
            variant: ArcoButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
