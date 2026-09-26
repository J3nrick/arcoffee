import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_constants.dart';
import '../../core/design/app_breakpoints.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_radii.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';
import 'arco_button.dart';

/// Floating Centered Liquid Glass Navigation Bar for Arcoffee.
class ArcoNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onOrderPressed;

  const ArcoNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12.0 : AppBreakpoints.horizontalPadding(context),
        vertical: isMobile ? 8.0 : 16.0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: ClipRRect(
          borderRadius: isMobile ? AppRadii.xl : AppRadii.xxl,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: isMobile ? 56 : 64,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.glassNight : AppColors.glassDay,
                borderRadius: isMobile ? AppRadii.xl : AppRadii.xxl,
                border: Border.all(
                  color: isDark
                      ? const Color(0x338FA2B5)
                      : AppColors.pureWhite.withOpacity(0.6),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0x66000000)
                        : AppColors.deepBlue.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Logo
                  _buildBrandLogo(theme, isDark),

                  // Center Nav Items
                  if (!isMobile) _buildDesktopNavItems(theme, isDark),

                  // Right Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildThemeToggle(theme, isDark, isMobile),
                      if (!isMobile) ...[
                        const SizedBox(width: 12),
                        ArcoButton(
                          text: "Order Now",
                          onPressed: onOrderPressed,
                          variant: ArcoButtonVariant.primary,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandLogo(ThemeController theme, bool isDark) {
    return GestureDetector(
      onTap: () => onTabSelected(0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
                borderRadius: AppRadii.md,
              ),
              alignment: Alignment.center,
              child: const Text(
                "ar",
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ARCOFFEE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                  ),
                ),
                Text(
                  AppConstants.slogan,
                  style: AppTypography.eyebrow.copyWith(
                    fontSize: 9,
                    color: AppColors.accentOrange,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNavItems(ThemeController theme, bool isDark) {
    final navItems = ["Home", "Menu", "Community", "Location & Hours"];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(navItems.length, (index) {
        final isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: GestureDetector(
            onTap: () => onTabSelected(index),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: AppMotion.fast,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentOrange.withOpacity(0.12)
                      : CupertinoColors.transparent,
                  borderRadius: AppRadii.md,
                ),
                child: Text(
                  navItems[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.accentOrange
                        : (isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildThemeToggle(ThemeController theme, bool isDark, bool isMobile) {
    return GestureDetector(
      onTap: () => theme.toggleTheme(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF192C3D) : AppColors.deepBlue.withOpacity(0.06),
            borderRadius: AppRadii.pill,
            border: Border.all(
              color: isDark ? AppColors.accentOrange.withOpacity(0.5) : AppColors.courtLineDay,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? CupertinoIcons.moon_stars_fill : CupertinoIcons.sun_max_fill,
                size: 14,
                color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
              ),
              if (!isMobile) ...[
                const SizedBox(width: 6),
                Text(
                  isDark ? "Midnight" : "Day Court",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
