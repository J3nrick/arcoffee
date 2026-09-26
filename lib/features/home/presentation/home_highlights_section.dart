import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_typography.dart';
import '../../../core/utils/image_precacher.dart';
import '../../../data/models/menu_item.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_court_line.dart';
import '../../../theme/theme_controller.dart';
import '../../menu/presentation/widgets/build_drink_modal.dart';

/// Editorial Signature Drinks Section for Arcoffee.
/// Implements the exact blueprint: Large Product Photo (Focal Point) on the Left
/// and an editorial list format on the Right, creating dynamic scale contrast.
class HomeHighlightsSection extends StatelessWidget {
  final List<MenuItem> featuredItems;
  final VoidCallback onExploreFullMenu;

  const HomeHighlightsSection({
    super.key,
    required this.featuredItems,
    required this.onExploreFullMenu,
  });

  // Flagship drink imagery: Rich malt Milo overload with thick crema and espresso shot
  static const String _flagshipImageUrl =
      'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=1000&q=85';

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final horizontalPad = AppBreakpoints.horizontalPadding(context);

    // Identify flagship drink or fallback to first item
    final flagshipItem = featuredItems.firstWhere(
      (item) => item.name.toLowerCase().contains('milo') || item.isBestseller,
      orElse: () => featuredItems.isNotEmpty
          ? featuredItems.first
          : const MenuItem(
              id: 'flagship',
              name: 'Milo Overload & Espresso Rush',
              description: 'Rich Milo malt overload paired with a double shot of signature espresso and thick cream.',
              category: MenuCategory.nonCoffee,
              price: 160.0,
            ),
    );

    // Supporting drinks (exclude flagship to avoid repetition)
    final supportingItems = featuredItems
        .where((item) => item.id != flagshipItem.id)
        .take(3)
        .toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isDesktop ? 64.0 : 36.0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header & Brand Monospaced Label
            Text(
              "AR / 002   |   SIGNATURE DRINKS",
              style: AppTypography.scoreboard.copyWith(
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
              ),
            ),
            const SizedBox(height: 12),
            ArcoCourtLine(
              width: double.infinity,
              height: 1.2,
              color: isDark ? AppColors.courtLineNight : AppColors.courtLineDay,
            ),
            const SizedBox(height: 36),

            // Editorial Asymmetric Layout
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT: Large Product Photo Focal Point (55% Width)
                  Expanded(
                    flex: 55,
                    child: _buildFlagshipShowcase(context, flagshipItem, isDark),
                  ),
                  const SizedBox(width: 48),

                  // RIGHT: Curated Supporting Drinks List (45% Width)
                  Expanded(
                    flex: 45,
                    child: _buildSupportingDrinksList(context, supportingItems, isDark),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFlagshipShowcase(context, flagshipItem, isDark, height: 340),
                  const SizedBox(height: 36),
                  _buildSupportingDrinksList(context, supportingItems, isDark),
                ],
              ),

            const SizedBox(height: 40),
            // Bottom Action
            Center(
              child: ArcoButton(
                text: "Explore Full Menu →",
                onPressed: onExploreFullMenu,
                variant: ArcoButtonVariant.ghost,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Large Flagship Drink Showcase
  Widget _buildFlagshipShowcase(BuildContext context, MenuItem item, bool isDark, {double height = 440}) {
    return GestureDetector(
      onTap: () => BuildDrinkModal.show(context, item),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceNightL2 : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withOpacity(0.08),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepBlue.withOpacity(isDark ? 0.35 : 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Product Photograph
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ArcoffeeNetworkImage(
                    imageUrl: _flagshipImageUrl,
                    fit: BoxFit.cover,
                    borderRadius: 0,
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.accentOrange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "01 / FLAGSHIP",
                        style: AppTypography.scoreboard.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.pureWhite,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Product Narrative
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name.toUpperCase(),
                          style: AppTypography.headingXL.copyWith(
                            fontSize: 22,
                            letterSpacing: -0.6,
                            color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.displayPrice,
                          style: AppTypography.priceTag.copyWith(
                            fontSize: 24,
                            color: AppColors.accentOrange,
                          ),
                        ),
                        Text(
                          "Customize Drink →",
                          style: AppTypography.scoreboard.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
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
    );
  }

  /// Curated List of Supporting Drinks (No Generic Cards)
  Widget _buildSupportingDrinksList(BuildContext context, List<MenuItem> items, bool isDark) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.asMap().entries.map((entry) {
        final index = entry.key + 2;
        final item = entry.value;
        final isLast = entry.key == items.length - 1;

        return Column(
          children: [
            GestureDetector(
              onTap: () => BuildDrinkModal.show(context, item),
              child: Container(
                color: CupertinoColors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Index Identifier
                    Text(
                      "0$index",
                      style: AppTypography.scoreboard.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.accentOrange,
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Drink Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name.toUpperCase(),
                            style: AppTypography.heading.copyWith(
                              fontSize: 18,
                              letterSpacing: -0.4,
                              color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                            ),
                          ),
                          const SizedBox(height: 4),
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
                    ),
                    const SizedBox(width: 20),

                    // Price Tag
                    Text(
                      item.displayPrice,
                      style: AppTypography.priceTag.copyWith(
                        fontSize: 18,
                        color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!isLast)
              ArcoCourtLine(
                width: double.infinity,
                height: 0.8,
                color: isDark ? AppColors.courtLineNight : AppColors.courtLineDay,
              ),
          ],
        );
      }).toList(),
    );
  }
}
