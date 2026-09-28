import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../../core/design/app_breakpoints.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_radii.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';
import 'arco_button.dart';
import 'arco_logo.dart';

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
                      : AppColors.pureWhite.withValues(alpha: 0.6),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? const Color(0x66000000)
                        : AppColors.deepBlue.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand Logo
                  _buildBrandLogo(theme, isDark, isMobile),

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

  Widget _buildBrandLogo(ThemeController theme, bool isDark, bool isMobile) {
    return ArcoLogo(
      height: isMobile ? 24 : 28,
      showText: true,
      showSlogan: !isMobile,
      onTap: () => onTabSelected(0),
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
                      ? AppColors.accentOrange.withValues(alpha: 0.12)
                      : CupertinoColors.transparent,
                  borderRadius: AppRadii.md,
                ),
                child: Text(
                  navItems[index],
                  style: TextStyle(
                    fontFamily: AppTypography.displayFont,
                    fontFamilyFallback: AppTypography.displayFontFallback,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    letterSpacing: -0.2,
                    color: isSelected
                        ? AppColors.accentOrange
                        : (isDark ? AppColors.textSecondaryNight : AppColors.textPrimaryDay),
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
            color: isDark ? const Color(0xFF192C3D) : AppColors.deepBlue.withValues(alpha: 0.06),
            borderRadius: AppRadii.pill,
            border: Border.all(
              color: isDark ? AppColors.accentOrange.withValues(alpha: 0.5) : AppColors.courtLineDay,
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
                    fontFamily: AppTypography.monoFont,
                    fontFamilyFallback: AppTypography.monoFontFallback,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
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
