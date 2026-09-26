import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/menu_item.dart';
import '../../../shared/widgets/badge_pill.dart';
import '../../../shared/widgets/frosted_glass_container.dart';
import '../../menu/presentation/widgets/menu_card.dart';
import '../../menu/presentation/widgets/build_drink_modal.dart';

/// Featured section highlighting the crowd favorites and the pickleball community partnership.
class HomeHighlightsSection extends StatelessWidget {
  final List<MenuItem> featuredItems;
  final VoidCallback onExploreFullMenu;

  const HomeHighlightsSection({
    super.key,
    required this.featuredItems,
    required this.onExploreFullMenu,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 36),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BadgePill(
                        label: "COURT CROWD FAVORITES",
                        icon: CupertinoIcons.flame_fill,
                        backgroundColor: Color(0xFFFFEAD9),
                        textColor: AppColors.accentOrange,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Signature Menu Highlights",
                        style: AppTypography.title1.copyWith(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Iconic creations that made Arcoffee Cavite's top courtside hangout.",
                        style: AppTypography.callout.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.primaryBlue.withOpacity(0.08),
                  onPressed: onExploreFullMenu,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "View All Series",
                        style: TextStyle(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        CupertinoIcons.chevron_right,
                        size: 14,
                        color: AppColors.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Responsive Highlights Grid
            _buildHighlightsGrid(context),
            const SizedBox(height: 48),

            // Sports & Community Callout Card
            _buildCommunityBanner(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightsGrid(BuildContext context) {
    final columns = Responsive.getGridColumnCount(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSpacing = (columns - 1) * 16.0;
        final itemWidth = (constraints.maxWidth - totalSpacing) / columns;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: featuredItems.take(3).map((item) {
            return SizedBox(
              width: itemWidth,
              height: 330,
              child: MenuCard(
                item: item,
                onTap: () => BuildDrinkModal.show(context, item),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCommunityBanner(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return FrostedGlassContainer(
      borderRadius: 22,
      backgroundColor: AppColors.primaryBlue,
      borderColor: AppColors.primaryBlue.withOpacity(0.2),
      padding: EdgeInsets.all(isDesktop ? 36.0 : 22.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "THE PICKLEGROUND ADVANTAGE",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pureWhite,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Cavite's Hotspot",
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.pureWhite.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  "More than a coffee shop.\nIt's a lifestyle stadium.",
                  style: AppTypography.title2.copyWith(
                    color: AppColors.pureWhite,
                    fontSize: isDesktop ? 26 : 20,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Located directly inside The Pickleground PH. Watch live matches while sipping an iced Haw-Haw Matcha or step onto the court fueled by our slow-steeped cold brew.",
                  style: AppTypography.body.copyWith(
                    color: AppColors.pureWhite.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 36),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.pureWhite.withOpacity(0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentOrange.withOpacity(0.5),
                  width: 2.0,
                ),
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.sportscourt_fill,
                  size: 54,
                  color: AppColors.courtOrange,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
