import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../theme/theme_controller.dart';

/// Apple HIG Navigation Toolbar with frosted glass blur, responsive tabs,
/// action button, and sleek Midnight Court theme switcher.
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

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 64,
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.horizontalPadding(context),
          ),
          decoration: BoxDecoration(
            color: theme.glassBackground,
            border: Border(
              bottom: BorderSide(
                color: theme.borderLight,
                width: 0.8,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand Identifier
              _buildBrandIdentifier(theme, isDark),

              // Desktop Navigation Tabs
              if (!isMobile) _buildDesktopNavTabs(theme, isDark),

              // Right Actions: Midnight Court Toggle + Menu Button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildThemeToggle(theme, isDark, isMobile),
                  const SizedBox(width: 10),
                  _buildActionButton(isMobile),
                ],
              ),
            ],
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
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? AppColors.accentOrange : AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: AppColors.accentOrange.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.primaryBlue.withOpacity(0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
              alignment: Alignment.center,
              child: const Text(
                "ar",
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ARCOFFEE",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: theme.primaryText,
                  ),
                ),
                Text(
                  AppConstants.slogan,
                  style: AppTypography.caption2.copyWith(
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNavTabs(ThemeController theme, bool isDark) {
    final tabs = [
      ("Home", CupertinoIcons.house_fill),
      ("Menu", CupertinoIcons.circle_grid_hex_fill),
      ("Community Board", CupertinoIcons.person_3_fill),
      ("Location & Hours", CupertinoIcons.location_fill),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(tabs.length, (index) {
        final isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            borderRadius: BorderRadius.circular(8),
            color: isSelected
                ? (isDark ? const Color(0x33FFFFFF) : AppColors.primaryBlue.withOpacity(0.07))
                : CupertinoColors.transparent,
            minSize: 36,
            onPressed: () => onTabSelected(index),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  tabs[index].$2,
                  size: 15,
                  color: isSelected ? AppColors.accentOrange : theme.secondaryText,
                ),
                const SizedBox(width: 6),
                Text(
                  tabs[index].$1,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? theme.primaryText : theme.secondaryText,
                  ),
                ),
              ],
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
              AnimatedRotation(
                turns: isDark ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  isDark ? CupertinoIcons.moon_stars_fill : CupertinoIcons.sun_max_fill,
                  size: 14,
                  color: isDark ? AppColors.accentOrange : AppColors.warmCoffee,
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 6),
                Text(
                  isDark ? "Midnight Court" : "Day Court",
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

  Widget _buildActionButton(bool isMobile) {
    return CupertinoButton(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 16,
        vertical: 8,
      ),
      borderRadius: BorderRadius.circular(20),
      color: AppColors.accentOrange,
      minSize: 36,
      onPressed: onActionPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            CupertinoIcons.flame_fill,
            size: 14,
            color: AppColors.pureWhite,
          ),
          const SizedBox(width: 6),
          Text(
            isMobile ? "Menu" : "Explore Menu",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.pureWhite,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
