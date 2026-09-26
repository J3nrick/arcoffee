import 'package:flutter/cupertino.dart';
import '../../core/constants/app_constants.dart';
import '../../core/design/app_breakpoints.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';
import 'arco_court_line.dart';

/// Minimal Editorial Brand Footer for Arcoffee.
/// Matches the blueprint: Large typography, slogan, and category pillars.
class ArcoFooter extends StatelessWidget {
  final ValueChanged<int>? onNavigate;

  const ArcoFooter({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isDesktop = AppBreakpoints.isDesktop(context);

    return Container(
      width: double.infinity,
      color: isDark ? AppColors.surfaceNightL1 : AppColors.surfaceDayL1,
      padding: EdgeInsets.symmetric(
        horizontal: AppBreakpoints.horizontalPadding(context),
        vertical: 56,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: Column(
          children: [
            ArcoCourtLine(
              width: double.infinity,
              height: 1.2,
              color: isDark ? AppColors.courtLineNight : AppColors.courtLineDay,
            ),
            const SizedBox(height: 48),

            // Large Center Editorial Brand Statement
            Text(
              "ARCOFFEE",
              style: AppTypography.displayXL.copyWith(
                fontSize: isDesktop ? 44 : 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
                color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "\"${AppConstants.slogan}\"".toUpperCase(),
              style: AppTypography.scoreboard.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
                color: AppColors.accentOrange,
              ),
            ),
            const SizedBox(height: 20),

            // Category Pillars
            Text(
              "COFFEE  /  COMMUNITY  /  SPORT  /  NIGHTLIFE",
              style: AppTypography.scoreboard.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Navigation Links Row
            Wrap(
              spacing: 28,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildFooterLink("HOME", 0, isDark),
                _buildFooterLink("MENU", 1, isDark),
                _buildFooterLink("COMMUNITY", 2, isDark),
                _buildFooterLink("LOCATION", 3, isDark),
              ],
            ),
            const SizedBox(height: 40),

            ArcoCourtLine(
              width: 160,
              height: 1.0,
              color: isDark ? AppColors.courtLineNight : AppColors.courtLineDay,
            ),
            const SizedBox(height: 20),

            // Bottom Receipt Metadata
            Text(
              "© ${DateTime.now().year} ARCOFFEE CO.  •  THE PICKLEGROUND PH, KAWIT, CAVITE  •  24H WEEKEND SESSION",
              style: AppTypography.receipt.copyWith(
                fontSize: 11,
                letterSpacing: 0.8,
                color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(String label, int index, bool isDark) {
    return GestureDetector(
      onTap: () => onNavigate?.call(index),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Text(
          label,
          style: AppTypography.scoreboard.copyWith(
            fontSize: 12,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
          ),
        ),
      ),
    );
  }
}
