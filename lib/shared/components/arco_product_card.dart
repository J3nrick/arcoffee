import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_radii.dart';
import '../../core/design/app_shadows.dart';
import '../../core/design/app_typography.dart';
import '../../data/models/menu_item.dart';
import '../../theme/theme_controller.dart';
import 'arco_badge.dart';

enum ArcoCardVariant {
  featured,
  standard,
  compact,
}

/// Editorial Product Card Component for Arcoffee.
/// Uses solid Level 2 surfaces (no glass on content layer) with asymmetric layouts.
class ArcoProductCard extends StatefulWidget {
  final MenuItem item;
  final VoidCallback onTap;
  final ArcoCardVariant variant;

  const ArcoProductCard({
    super.key,
    required this.item,
    required this.onTap,
    this.variant = ArcoCardVariant.standard,
  });

  @override
  State<ArcoProductCard> createState() => _ArcoProductCardState();
}

class _ArcoProductCardState extends State<ArcoProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final item = widget.item;

    final cardBg = isDark ? AppColors.surfaceNightL2 : AppColors.surfaceDayL2;

    switch (widget.variant) {
      case ArcoCardVariant.featured:
        return _buildFeaturedLayout(item, theme, isDark, cardBg);
      case ArcoCardVariant.compact:
        return _buildCompactLayout(item, theme, isDark, cardBg);
      case ArcoCardVariant.standard:
      default:
        return _buildStandardLayout(item, theme, isDark, cardBg);
    }
  }

  Widget _buildStandardLayout(MenuItem item, ThemeController theme, bool isDark, Color cardBg) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          transform: Matrix4.translationValues(0, _isHovered ? -4.0 : 0.0, 0),
          decoration: BoxDecoration(
            color: _isHovered
                ? (isDark ? const Color(0xFF142436) : AppColors.pureWhite)
                : cardBg,
            borderRadius: AppRadii.xl,
            border: Border.all(
              color: _isHovered
                  ? item.accentColor.withOpacity(0.6)
                  : (isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withOpacity(0.08)),
              width: 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: item.accentColor.withOpacity(isDark ? 0.35 : 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : AppShadows.cardShadow(isDark),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge & Special Tags
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ArcoBadge(
                        label: item.category.displayName,
                        icon: item.category.icon,
                        textColor: item.accentColor,
                        backgroundColor: item.accentColor.withOpacity(isDark ? 0.2 : 0.1),
                      ),
                      if (item.isBestseller)
                        const ArcoBadge(
                          label: '★ BESTSELLER',
                          backgroundColor: Color(0xFFFFEAD9),
                          textColor: AppColors.accentOrange,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Drink Graphic Visual Box
                  _buildGraphicVisual(item),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    item.name,
                    style: AppTypography.heading.copyWith(
                      color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Description
                  Text(
                    item.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bottom Price & Customize Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.displayPrice,
                        style: AppTypography.priceTag.copyWith(
                          color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
                        ),
                      ),
                      Text(
                        item.size,
                        style: AppTypography.receipt.copyWith(
                          color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay,
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: AppMotion.fast,
                    constraints: const BoxConstraints(minHeight: 44.0, minWidth: 44.0),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? AppColors.accentOrange
                          : (isDark ? const Color(0x33FFFFFF) : AppColors.deepBlue.withOpacity(0.08)),
                      borderRadius: AppRadii.lg,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Customize",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _isHovered
                                ? AppColors.pureWhite
                                : (isDark ? AppColors.pureWhite : AppColors.deepBlue),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          CupertinoIcons.slider_horizontal_3,
                          size: 13,
                          color: _isHovered
                              ? AppColors.pureWhite
                              : (isDark ? AppColors.pureWhite : AppColors.deepBlue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedLayout(MenuItem item, ThemeController theme, bool isDark, Color cardBg) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          transform: Matrix4.translationValues(0, _isHovered ? -4.0 : 0.0, 0),
          decoration: BoxDecoration(
            color: _isHovered
                ? (isDark ? const Color(0xFF142436) : AppColors.pureWhite)
                : cardBg,
            borderRadius: AppRadii.xxl,
            border: Border.all(
              color: item.accentColor.withOpacity(0.4),
              width: 1.2,
            ),
            boxShadow: AppShadows.cardShadow(isDark),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ArcoBadge(
                label: "FEATURED HIGHLIGHT",
                icon: CupertinoIcons.sparkles,
                backgroundColor: AppColors.accentOrange.withOpacity(0.15),
                textColor: AppColors.accentOrange,
              ),
              const SizedBox(height: 16),
              _buildGraphicVisual(item, height: 140),
              const SizedBox(height: 16),
              Text(
                item.name,
                style: AppTypography.headingXL.copyWith(
                  color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: AppTypography.body.copyWith(
                  color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.displayPrice,
                    style: AppTypography.display.copyWith(
                      fontSize: 28,
                      color: AppColors.accentOrange,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange,
                      borderRadius: AppRadii.lg,
                    ),
                    child: const Text(
                      "Build Drink",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactLayout(MenuItem item, ThemeController theme, bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.accentColor.withOpacity(0.15),
              borderRadius: AppRadii.md,
            ),
            child: Icon(item.category.icon, color: item.accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.headingSmall.copyWith(
                    color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                  ),
                ),
                Text(
                  item.displayPrice,
                  style: AppTypography.receipt.copyWith(
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphicVisual(MenuItem item, {double height = 96}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: item.accentColor.withOpacity(0.12),
        borderRadius: AppRadii.lg,
        border: Border.all(color: item.accentColor.withOpacity(0.25), width: 0.8),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.pureWhite,
              shape: BoxShape.circle,
            ),
            child: Icon(item.category.icon, color: item.accentColor, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            item.caffeineNote,
            style: AppTypography.eyebrow.copyWith(
              fontSize: 10,
              color: item.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
