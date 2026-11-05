import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/design/app_breakpoints.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';
import 'arco_court_line.dart';
import 'arco_logo.dart';
import 'arco_text_link.dart';

/// Minimal Editorial Brand Footer for Arcoffee.
/// Matches the blueprint: Large typography, slogan, and category pillars.
class ArcoFooter extends StatelessWidget {
  final ValueChanged<int>? onNavigate;

  /// Hidden on Home, which closes with its own Join the Club section.
  final bool showJoin;

  const ArcoFooter({super.key, this.onNavigate, this.showJoin = true});

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

            // Official Logo Mark & Editorial Colophon
            ArcoLogo(
              height: isDesktop ? 48 : 38,
              showText: false,
              onTap: () => onNavigate?.call(0),
            ),
            const SizedBox(height: 18),

            // Large Center Editorial Brand Statement
            Text(
              "ARCOFFEE",
              style: AppTypography.displayXL.copyWith(
                fontSize: isDesktop ? 40 : 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
                color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "“${AppConstants.slogan}”".toUpperCase(),
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
            const SizedBox(height: 36),

            // "Join the Club" Community Subscription
            if (showJoin) ...[
              const ArcoJoinForm(),
              const SizedBox(height: 40),
            ],

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
            const SizedBox(height: 24),

            // Official Social Handles from Printed Menu Board
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildSocialBadge("IG", "@arcoffeeph", "https://www.instagram.com/arcoffeeph/", isDark),
                _buildSocialBadge("FB", "@ARCoffee", "https://www.facebook.com/ARCoffee/", isDark),
                _buildSocialBadge("TIKTOK", "@arcoffeeph", "https://www.tiktok.com/@arcoffeeph", isDark),
              ],
            ),
            const SizedBox(height: 36),

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

  Widget _buildSocialBadge(String platform, String handle, String url, bool isDark) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$platform  ",
                style: AppTypography.scoreboard.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                  color: AppColors.accentOrange,
                ),
              ),
              Text(
                handle,
                style: AppTypography.receipt.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textSecondaryNight : AppColors.deepBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Join the Club": follow on Instagram. There is no mailing list yet, so nothing is collected here.
class ArcoJoinForm extends StatelessWidget {
  final bool showHeading;
  const ArcoJoinForm({super.key, this.showHeading = true});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeScope.of(context).isMidnightCourt;
    return Column(
      children: [
        if (showHeading) ...[
          Text(
            "JOIN THE CLUB",
            style: AppTypography.scoreboard.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
              color: AppColors.accentOrange,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Session schedules, court drops & off-menu creations, posted first on Instagram.",
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
        ],
        ArcoTextLink(
          label: 'Follow @arcoffee.ph',
          color: isDark ? AppColors.pureWhite : AppColors.deepBlue,
          onTap: () => launchUrl(Uri.parse(AppConstants.instagramUrl), mode: LaunchMode.externalApplication),
        ),
      ],
    );
  }
}
