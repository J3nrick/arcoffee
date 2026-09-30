import 'package:flutter/cupertino.dart';
import '../../core/constants/app_constants.dart';
import '../../core/design/app_breakpoints.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';
import 'arco_court_line.dart';
import 'arco_logo.dart';

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
            const SizedBox(height: 36),

            // "Join the Club" Community Subscription
            const _JoinTheClubSection(),
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
            const SizedBox(height: 24),

            // Official Social Handles from Printed Menu Board
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildSocialBadge("IG", "@arcoffeeph", isDark),
                _buildSocialBadge("FB", "@ARCoffee", isDark),
                _buildSocialBadge("TIKTOK", "@arcoffeeph", isDark),
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

  Widget _buildSocialBadge(String platform, String handle, bool isDark) {
    return Container(
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
    );
  }
}

class _JoinTheClubSection extends StatefulWidget {
  const _JoinTheClubSection();

  @override
  State<_JoinTheClubSection> createState() => _JoinTheClubSectionState();
}

class _JoinTheClubSectionState extends State<_JoinTheClubSection> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSubscribed = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubscribe() {
    final text = _emailController.text.trim();
    if (text.isNotEmpty && text.contains('@')) {
      setState(() => _isSubscribed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isMobile = AppBreakpoints.isMobile(context);

    if (_isSubscribed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0x22F36622) : const Color(0x14F36622),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accentOrange.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.checkmark_seal_fill, size: 18, color: AppColors.accentOrange),
            const SizedBox(width: 10),
            Text(
              "WELCOME TO THE CLUB. YOU'RE ON THE LIST.",
              style: AppTypography.scoreboard.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: isDark ? AppColors.pureWhite : AppColors.deepBlue,
              ),
            ),
          ],
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
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
            "Receive nocturnal session schedules, court drops & off-menu creations.",
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),
          if (isMobile)
            Column(
              children: [
                _buildEmailInput(isDark),
                const SizedBox(height: 10),
                _buildSubmitButton(isDark, isFullWidth: true),
              ],
            )
          else
            Row(
              children: [
                Expanded(child: _buildEmailInput(isDark)),
                const SizedBox(width: 10),
                _buildSubmitButton(isDark, isFullWidth: false),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmailInput(bool isDark) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F263D) : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0x338FA2B5) : AppColors.softSand,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      child: CupertinoTextField(
        controller: _emailController,
        placeholder: "Enter your email for court drops...",
        placeholderStyle: TextStyle(
          fontFamily: AppTypography.bodyFont,
          fontFamilyFallback: AppTypography.bodyFontFallback,
          fontSize: 13,
          color: isDark ? const Color(0xFF5A758E) : const Color(0xFF9E9B93),
        ),
        style: TextStyle(
          fontFamily: AppTypography.bodyFont,
          fontFamilyFallback: AppTypography.bodyFontFallback,
          fontSize: 13,
          color: isDark ? AppColors.pureWhite : AppColors.deepBlue,
        ),
        decoration: null,
        cursorColor: AppColors.accentOrange,
        keyboardType: TextInputType.emailAddress,
        onSubmitted: (_) => _handleSubscribe(),
      ),
    );
  }

  Widget _buildSubmitButton(bool isDark, {required bool isFullWidth}) {
    return SizedBox(
      height: 44,
      width: isFullWidth ? double.infinity : null,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: AppColors.accentOrange,
        borderRadius: BorderRadius.circular(8),
        onPressed: _handleSubscribe,
        child: Text(
          "Join the Club",
          style: TextStyle(
            fontFamily: AppTypography.displayFont,
            fontFamilyFallback: AppTypography.displayFontFallback,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.pureWhite,
          ),
        ),
      ),
    );
  }
}
