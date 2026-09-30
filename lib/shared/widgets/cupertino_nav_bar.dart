import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../theme/theme_controller.dart';

/// Rebuilt Floating Liquid Glass Navigation Bar for Arcoffee.
/// Features a centered floating pill design with BackdropFilter gaussian blur,
/// translucent glass fill, minimal navigation links, and Day/Midnight Court toggle.
class CupertinoCustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onActionPressed;

  const CupertinoCustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12.0 : Responsive.horizontalPadding(context),
        vertical: isMobile ? 8.0 : 16.0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppConstants.desktopMaxWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: isMobile ? 56 : 64,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xCC0B1824)
                    : AppColors.pureWhite.withOpacity(0.82),
                borderRadius: BorderRadius.circular(isMobile ? 18 : 24),
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
                        : AppColors.primaryBlue.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Minimal Brand Logo
                  _buildBrandIdentifier(theme, isDark),

                  // Center: Clean Navigation Links (Desktop/Tablet)
                  if (!isMobile) _buildNavLinks(theme, isDark),

                  // Right: Day/Midnight Theme Toggle
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildThemeToggle(theme, isDark, isMobile),
                      if (!isMobile) ...[
                        const SizedBox(width: 12),
                        _buildMenuCtaButton(),
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

  Widget _buildBrandIdentifier(ThemeController theme, bool isDark) {
    return GestureDetector(
      onTap: () => onTabSelected(0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDark ? AppColors.accentOrange : AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(10),
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
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: theme.primaryText,
                  ),
                ),
                Text(
                  AppConstants.slogan,
                  style: AppTypography.caption2.copyWith(
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavLinks(ThemeController theme, bool isDark) {
    final links = [
      "Home",
      "Menu",
      "Community",
      "Location & Hours",
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(links.length, (index) {
        final isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? (isDark ? const Color(0x33FFFFFF) : AppColors.accentOrange.withOpacity(0.12))
                : CupertinoColors.transparent,
            minSize: 36,
            onPressed: () => onTabSelected(index),
            child: Text(
              links[index],
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppColors.accentOrange : AppColors.accentOrange)
                    : theme.secondaryText,
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF192C3D) : AppColors.primaryBlue.withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.accentOrange.withOpacity(0.5) : AppColors.borderLight,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark ? CupertinoIcons.moon_stars_fill : CupertinoIcons.sun_max_fill,
                size: 14,
                color: isDark ? AppColors.accentOrange : AppColors.warmCoffee,
              ),
              if (!isMobile) ...[
                const SizedBox(width: 6),
                Text(
                  isDark ? "Midnight" : "Day Court",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.accentOrange : AppColors.textPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCtaButton() {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      borderRadius: BorderRadius.circular(16),
      color: AppColors.accentOrange,
      minSize: 36,
      onPressed: onActionPressed,
      child: const Text(
        "Order to Court",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.pureWhite,
        ),
      ),
    );
  }
}
