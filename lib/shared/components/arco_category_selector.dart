import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_radii.dart';
import '../../core/design/app_typography.dart';
import '../../data/models/menu_item.dart';
import '../../theme/theme_controller.dart';

/// Editorial Horizontal Category Selector for Arcoffee.
class ArcoCategorySelector extends StatelessWidget {
  final MenuCategory selectedCategory;
  final ValueChanged<MenuCategory> onCategorySelected;

  const ArcoCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: MenuCategory.values.map((cat) {
          final isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => onCategorySelected(cat),
                child: AnimatedContainer(
                  duration: AppMotion.fast,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accentOrange
                        : (isDark ? const Color(0xFF142434) : AppColors.deepBlue.withValues(alpha: 0.05)),
                    borderRadius: AppRadii.lg,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentOrange
                          : (isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withValues(alpha: 0.1)),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        cat.icon,
                        size: 15,
                        color: isSelected
                            ? AppColors.pureWhite
                            : (isDark ? AppColors.textSecondaryNight : AppColors.deepBlue),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        cat.displayName.toUpperCase(),
                        style: TextStyle(
                          fontFamily: AppTypography.displayFont,
                          fontFamilyFallback: AppTypography.displayFontFallback,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          letterSpacing: 0.8,
                          color: isSelected
                              ? AppColors.pureWhite
                              : (isDark ? AppColors.textPrimaryNight : AppColors.deepBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
