import 'package:flutter/cupertino.dart';
import '../../core/constants/app_constants.dart';
import '../../core/design/app_breakpoints.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';
import 'arco_court_line.dart';
import 'arco_sticker.dart';

/// Minimal Editorial Brand Footer for Arcoffee.
class ArcoFooter extends StatelessWidget {
  final ValueChanged<int>? onNavigate;

  const ArcoFooter({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isMobile = AppBreakpoints.isMobile(context);

    return Container(
      width: double.infinity,
      color: isDark ? AppColors.surfaceNightL1 : AppColors.surfaceDayL1,
      padding: EdgeInsets.symmetric(
        horizontal: AppBreakpoints.horizontalPadding(context),
        vertical: 48,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ArcoCourtLine(),
            const SizedBox(height: 32),
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBrandBlock(theme, isDark),
                  const SizedBox(height: 32),
                  _buildFooterLinks(theme, isDark),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 5, child: _buildBrandBlock(theme, isDark)),
                  Expanded(flex: 5, child: _buildFooterLinks(theme, isDark)),
                ],
              ),
            const SizedBox(height: 48),
            const ArcoCourtLine(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "© ${DateTime.now().year} ARCOFFEE • ALL RIGHTS RESERVED",
                  style: AppTypography.receipt.copyWith(
                    fontSize: 11,
                    color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay,
                  ),
                ),
                Text(
                  "COURT-SIDE COFFEE CULTURE",
                  style: AppTypography.eyebrow.copyWith(
                    fontSize: 10,
                    color: AppColors.accentOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandBlock(ThemeController theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "ARCOFFEE",
              style: AppTypography.headingXL.copyWith(
                color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                letterSpacing: -1.0,
              ),
            ),
            const SizedBox(width: 12),
            const ArcoSticker(text: "COURT SIDE", rotation: -0.05),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "\"${AppConstants.slogan}\"",
          style: AppTypography.bodyLarge.copyWith(
            fontStyle: FontStyle.italic,
            color: AppColors.accentOrange,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "The Pickleground PH, Kawit / Noveleta, Cavite.\nMon–Thu: 2PM–10PM | Fri–Sun: 24 Hours",
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLinks(ThemeController theme, bool isDark) {
    final links = [
      ("Home", 0),
      ("Menu", 1),
      ("Community Board", 2),
      ("Location & Hours", 3),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "NAVIGATION",
              style: AppTypography.eyebrow.copyWith(
                color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay,
              ),
            ),
            const SizedBox(height: 12),
            ...links.map((link) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    onTap: () => onNavigate?.call(link.$2),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text(
                        link.$1,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CONNECT",
              style: AppTypography.eyebrow.copyWith(
                color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay,
              ),
            ),
            const SizedBox(height: 12),
            Text("Instagram: @arcoffee.ph",
                style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue)),
            const SizedBox(height: 8),
            Text("Facebook: /arcoffee.ph",
                style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue)),
            const SizedBox(height: 8),
            Text("TikTok: @arcoffee.ph",
                style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue)),
          ],
        ),
      ],
    );
  }
}
