import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
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
/// Showcases authentic drink photography with large, appetizing imagery,
/// prominent typography, authentic pricing, and smooth customization trigger.
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
        return _buildStandardLayout(item, theme, isDark, cardBg);
    }
  }

  Widget _buildStandardLayout(MenuItem item, ThemeController theme, bool isDark, Color cardBg) {
    final imageAsset = item.imageAsset;

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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? item.accentColor.withValues(alpha: 0.6)
                  : (isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withValues(alpha: 0.08)),
              width: 1.0,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: item.accentColor.withValues(alpha: isDark ? 0.35 : 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : AppShadows.cardShadow(isDark),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Prominent Product Photography Container (180px height)
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imageAsset != null)
                      AnimatedScale(
                        duration: AppMotion.standard,
                        scale: _isHovered ? 1.04 : 1.0,
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        color: item.accentColor.withValues(alpha: 0.12),
                        child: Center(
                          child: Icon(item.category.icon, size: 36, color: item.accentColor),
                        ),
                      ),

                    // Top Gradient Shade for Badge Readability
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.deepBlue.withValues(alpha: 0.5),
                              AppColors.deepBlue.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Top Left: Category Badge
                    Positioned(
                      top: 10,
                      left: 10,
                      child: ArcoBadge(
                        label: item.category.displayName.toUpperCase(),
                        textColor: AppColors.pureWhite,
                        backgroundColor: AppColors.deepBlue.withValues(alpha: 0.75),
                      ),
                    ),

                    // Top Right: Bestseller / Signature Mark
                    if (item.isBestseller)
                      const Positioned(
                        top: 10,
                        right: 10,
                        child: ArcoBadge(
                          label: '★ BESTSELLER',
                          backgroundColor: Color(0xFFFFEAD9),
                          textColor: AppColors.accentOrange,
                        ),
                      )
                    else if (item.isSignature)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: ArcoBadge(
                          label: 'SIGNATURE',
                          backgroundColor: AppColors.accentOrange.withValues(alpha: 0.9),
                          textColor: AppColors.pureWhite,
                        ),
                      ),

                    // Bottom Right: Caffeine / Serving Note
                    Positioned(
                      bottom: 8,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.deepBlue.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.caffeineNote.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: AppTypography.monoFont,
                            fontFamilyFallback: AppTypography.monoFontFallback,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.pureWhite,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Content Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Drink Title
                          Text(
                            item.name.toUpperCase(),
                            style: TextStyle(
                              fontFamily: AppTypography.displayFont,
                              fontFamilyFallback: AppTypography.displayFontFallback,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                              color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),

                          // Drink Description
                          Text(
                            item.description,
                            style: TextStyle(
                              fontFamily: AppTypography.bodyFont,
                              fontFamilyFallback: AppTypography.bodyFontFallback,
                              fontSize: 12,
                              height: 1.35,
                              color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),

                      // Bottom Price & Action Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.displayPrice,
                                style: const TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  fontFamilyFallback: AppTypography.monoFontFallback,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.accentOrange,
                                ),
                              ),
                              Text(
                                item.size,
                                style: TextStyle(
                                  fontFamily: AppTypography.monoFont,
                                  fontFamilyFallback: AppTypography.monoFontFallback,
                                  fontSize: 10,
                                  color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            constraints: const BoxConstraints(minHeight: 38.0),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _isHovered
                                  ? AppColors.accentOrange
                                  : (isDark ? const Color(0x33FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.08)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Customize",
                                  style: TextStyle(
                                    fontFamily: AppTypography.displayFont,
                                    fontFamilyFallback: AppTypography.displayFontFallback,
                                    fontSize: 12,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedLayout(MenuItem item, ThemeController theme, bool isDark, Color cardBg) {
    final imageAsset = item.imageAsset;

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
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: item.accentColor.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: AppShadows.cardShadow(isDark),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full-Width Large Featured Photo (200px)
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imageAsset != null)
                      Image.asset(
                        imageAsset,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(color: item.accentColor.withValues(alpha: 0.2)),
                    const Positioned(
                      top: 14,
                      left: 14,
                      child: ArcoBadge(
                        label: "FEATURED HIGHLIGHT",
                        icon: CupertinoIcons.sparkles,
                        backgroundColor: AppColors.accentOrange,
                        textColor: AppColors.pureWhite,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name.toUpperCase(),
                      style: AppTypography.headingXL.copyWith(
                        color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      style: AppTypography.body.copyWith(
                        color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.displayPrice,
                          style: const TextStyle(
                            fontFamily: AppTypography.monoFont,
                            fontFamilyFallback: AppTypography.monoFontFallback,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentOrange,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "Customize Drink",
                            style: TextStyle(
                              fontSize: 13,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactLayout(MenuItem item, ThemeController theme, bool isDark, Color cardBg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: item.imageAsset != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item.imageAsset!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(item.category.icon, color: item.accentColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name.toUpperCase(),
                  style: TextStyle(
                    fontFamily: AppTypography.displayFont,
                    fontFamilyFallback: AppTypography.displayFontFallback,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.displayPrice,
                  style: const TextStyle(
                    fontFamily: AppTypography.monoFont,
                    fontFamilyFallback: AppTypography.monoFontFallback,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentOrange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
