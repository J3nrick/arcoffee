import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../theme/theme_controller.dart';
import 'status_pill.dart';

/// Unified layout wrapper that enforces desktop web bounds and simulates a
/// sleek macOS application window complete with titlebar, traffic light controls,
/// and frosted glass visual depth with dynamic Day/Midnight Court aesthetics.
class MacOSWindowFrame extends StatelessWidget {
  final Widget child;
  final int activeIndex;
  final ValueChanged<int> onTabSelected;

  const MacOSWindowFrame({
    super.key,
    required this.child,
    required this.activeIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    if (!isDesktop) {
      // Fluid mobile/tablet rendering
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: theme.scaffoldBackground,
        child: SafeArea(
          top: false,
          bottom: true,
          child: child,
        ),
      );
    }

    // Sleek macOS Desktop Window Container
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      color: theme.desktopWallpaper,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: AppConstants.desktopMaxWidth,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.scaffoldBackground,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(
              color: isDark ? const Color(0x338FA2B5) : AppColors.borderLight,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? const Color(0x80000000)
                    : AppColors.deepNavy.withOpacity(0.12),
                blurRadius: 48,
                spreadRadius: isDark ? 2 : 0,
                offset: const Offset(0, 20),
              ),
              BoxShadow(
                color: isDark
                    ? AppColors.accentOrange.withOpacity(0.08)
                    : AppColors.deepNavy.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildMacOSTitleBar(context, theme, isDark),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacOSTitleBar(BuildContext context, ThemeController theme, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.titlebarBg,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0x228FA2B5) : AppColors.borderLight,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          // macOS Traffic Light Window Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _trafficDot(AppColors.macosTrafficRed),
              const SizedBox(width: 8),
              _trafficDot(AppColors.macosTrafficYellow),
              const SizedBox(width: 8),
              _trafficDot(AppColors.macosTrafficGreen),
            ],
          ),
          const SizedBox(width: 24),

          // Window Title
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDark ? CupertinoIcons.moon_stars_fill : CupertinoIcons.circle_grid_hex_fill,
                  size: 14,
                  color: AppColors.accentOrange,
                ),
                const SizedBox(width: 8),
                Text(
                  isDark
                      ? "Arcoffee — Midnight Court Session (24H)"
                      : "Arcoffee — The Pickleground PH",
                  style: AppTypography.caption1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0x33FFFFFF)
                        : AppColors.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Kawit, Cavite",
                    style: AppTypography.caption2.copyWith(
                      color: isDark ? const Color(0xFFFAF7F2) : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right Status & Quick Badge
          StatusPill(
            text: isDark ? "24H MIDNIGHT RUN" : "OPEN NOW",
            isOpen: true,
          ),
        ],
      ),
    );
  }

  Widget _trafficDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withOpacity(0.25),
          width: 0.5,
        ),
      ),
    );
  }
}
