import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_typography.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_court_line.dart';
import '../../../shared/components/arco_logo.dart';
import '../../../theme/theme_controller.dart';

/// Custom 404 Error Page for Arcoffee ("Court-side coffee culture").
/// Confident, athletic, and on-brand editorial view for unknown routes.
class OutOfBoundsView extends StatelessWidget {
  final VoidCallback onReturnToMenu;
  final VoidCallback? onReturnHome;

  const OutOfBoundsView({
    super.key,
    required this.onReturnToMenu,
    this.onReturnHome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final horizontalPad = AppBreakpoints.horizontalPadding(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackground,
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Brand Mark
                ArcoLogo(
                  height: 36,
                  showText: true,
                  color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
                ),
                const SizedBox(height: 32),

                // Monospaced Court Boundary Colophon
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0x22FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withValues(alpha: 0.1),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    "FAULT CALLED  •  LINE FOOT VIOLATION  •  CODE 404",
                    style: AppTypography.scoreboard.copyWith(
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Massive Editorial Headline
                Text(
                  "OUT OF BOUNDS.",
                  textAlign: TextAlign.center,
                  style: AppTypography.displayXL.copyWith(
                    fontSize: isDesktop ? 54 : 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.6,
                    height: 1.0,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 16),

                // Hairline court line
                ArcoCourtLine(
                  width: 140,
                  height: 1.5,
                  color: isDark ? AppColors.courtLineNight : AppColors.courtLineDay,
                ),
                const SizedBox(height: 20),

                // Subtitle
                Text(
                  "Let's get you back to the court.",
                  textAlign: TextAlign.center,
                  style: AppTypography.heading.copyWith(
                    fontSize: isDesktop ? 22 : 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentOrange,
                  ),
                ),
                const SizedBox(height: 12),

                // Narrative Copy
                Text(
                  "You've stepped past the tournament baseline. No game penalty assessed — let's redirect you back to the craft drink selection.",
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    fontSize: 15,
                    height: 1.5,
                    color: theme.secondaryText,
                  ),
                ),
                const SizedBox(height: 36),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ArcoButton(
                      text: "Return to Menu →",
                      onPressed: onReturnToMenu,
                      variant: ArcoButtonVariant.primary,
                    ),
                    if (onReturnHome != null) ...[
                      const SizedBox(width: 14),
                      ArcoButton(
                        text: "Home Court",
                        onPressed: onReturnHome!,
                        variant: ArcoButtonVariant.secondary,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
