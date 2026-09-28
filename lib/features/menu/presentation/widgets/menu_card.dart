import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/menu_item.dart';
import '../../../../shared/widgets/badge_pill.dart';
import '../../../../shared/widgets/custom_cursor.dart';
import '../../../../theme/theme_controller.dart';

/// Apple HIG macOS-style Drink Card featuring continuous liquid bobbing float physics,
/// dynamic colored glow shadows on hover, and custom cursor expansion.
class MenuCard extends StatefulWidget {
  final MenuItem item;
  final VoidCallback onTap;

  const MenuCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _liquidFloatController;

  @override
  void initState() {
    super.initState();
    _liquidFloatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void dispose() {
    _liquidFloatController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool hovered) {
    setState(() => _isHovered = hovered);
    CursorController.instance.setInteractive(hovered);
    if (hovered) {
      _liquidFloatController.repeat(reverse: true);
    } else {
      _liquidFloatController.animateTo(0.0, duration: const Duration(milliseconds: 200));
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (_) => _onHoverChanged(true),
        onExit: (_) => _onHoverChanged(false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _isHovered ? -7.0 : 0.0, 0),
            decoration: BoxDecoration(
              color: _isHovered
                  ? (isDark ? const Color(0xFF142436) : AppColors.pureWhite)
                  : theme.cardBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered
                    ? item.accentColor.withOpacity(0.65)
                    : theme.borderLight,
                width: 1.0,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: item.accentColor.withOpacity(isDark ? 0.45 : 0.28),
                        blurRadius: 32,
                        spreadRadius: 2,
                        offset: const Offset(0, 14),
                      ),
                    ]
                  : theme.cardElevationShadow,
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Row Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BadgePill(
                          label: item.category.displayName,
                          icon: item.category.icon,
                          backgroundColor: item.accentColor.withOpacity(isDark ? 0.22 : 0.12),
                          textColor: item.accentColor,
                          isSmall: true,
                        ),
                        if (item.isBestseller)
                          const BadgePill(
                            label: '★ BESTSELLER',
                            backgroundColor: AppColors.badgeHighlight,
                            textColor: AppColors.accentOrange,
                            isSmall: true,
                          )
                        else if (item.isCourtFavorite)
                          const BadgePill(
                            label: 'COURT PICK',
                            icon: CupertinoIcons.sportscourt_fill,
                            backgroundColor: Color(0xFFE8F5E9),
                            textColor: Color(0xFF2E7D32),
                            isSmall: true,
                          )
                        else if (item.isNew)
                          const BadgePill(
                            label: 'NEW',
                            backgroundColor: Color(0xFFEDE7F6),
                            textColor: Color(0xFF673AB7),
                            isSmall: true,
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Graphic Visual Banner with Liquid Bobbing Float
                    _buildLiquidDrinkVisual(item),
                    const SizedBox(height: 14),

                    // Drink Title
                    Text(
                      item.name,
                      style: AppTypography.headline.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Drink Description
                    Text(
                      item.description,
                      style: AppTypography.callout.copyWith(
                        fontSize: 13,
                        color: theme.secondaryText,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Bottom Price & Action Button
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
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.accentOrange : AppColors.primaryBlue,
                          ),
                        ),
                        Text(
                          item.size,
                          style: AppTypography.caption2.copyWith(
                            color: theme.tertiaryText,
                          ),
                        ),
                      ],
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      constraints: const BoxConstraints(minHeight: 44.0, minWidth: 44.0),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? AppColors.accentOrange
                            : (isDark ? const Color(0x33FFFFFF) : AppColors.primaryBlue.withOpacity(0.08)),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: AppColors.accentOrange.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Customize",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _isHovered
                                  ? AppColors.pureWhite
                                  : (isDark ? AppColors.pureWhite : AppColors.primaryBlue),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            CupertinoIcons.slider_horizontal_3,
                            size: 13,
                            color: _isHovered
                                ? AppColors.pureWhite
                                : (isDark ? AppColors.pureWhite : AppColors.primaryBlue),
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
      ),
    );
  }

  Widget _buildLiquidDrinkVisual(MenuItem item) {
    return AnimatedBuilder(
      animation: _liquidFloatController,
      builder: (context, child) {
        final floatOffset = math.sin(_liquidFloatController.value * math.pi) * -5.0;

        return Container(
          height: 94,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                item.accentColor.withOpacity(0.22),
                item.accentColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: item.accentColor.withOpacity(0.24),
              width: 0.8,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -15,
                bottom: -15,
                child: Icon(
                  CupertinoIcons.circle_grid_hex_fill,
                  size: 80,
                  color: item.accentColor.withOpacity(0.09),
                ),
              ),
              Center(
                child: Transform.translate(
                  offset: Offset(0, _isHovered ? floatOffset : 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite.withOpacity(0.92),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: item.accentColor.withOpacity(0.4),
                              blurRadius: _isHovered ? 18 : 10,
                              spreadRadius: _isHovered ? 2 : 0,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          item.category.icon,
                          color: item.accentColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.caffeineNote,
                        style: AppTypography.caption2.copyWith(
                          color: item.accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
