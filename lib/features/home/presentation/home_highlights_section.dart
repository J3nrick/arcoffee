import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/models/menu_item.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_product_card.dart';
import '../../../shared/components/arco_sticker.dart';
import '../../../theme/theme_controller.dart';
import '../../menu/presentation/widgets/build_drink_modal.dart';

/// Featured Highlights Section displaying signature drinks.
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
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final horizontalPad = AppBreakpoints.horizontalPadding(context);

    final displayItems = featuredItems.take(3).toList();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ArcoSticker(text: "SIGNATURE DRINKS", rotation: -0.02),
                    const SizedBox(height: 10),
                    Text(
                      "Courtside Bestsellers",
                      style: AppTypography.display.copyWith(
                        color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                        fontSize: isMobile ? 28 : 36,
                      ),
                    ),
                  ],
                ),
                if (!isMobile)
                  ArcoButton(
                    text: "View Full Menu",
                    onPressed: onExploreFullMenu,
                    variant: ArcoButtonVariant.ghost,
                  ),
              ],
            ),
            const SizedBox(height: 32),

            // Product Cards Grid
            if (isMobile)
              Column(
                children: displayItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ArcoProductCard(
                      item: item,
                      onTap: () => BuildDrinkModal.show(context, item),
                    ),
                  );
                }).toList(),
              )
            else if (isTablet)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.78,
                ),
                itemCount: displayItems.length,
                itemBuilder: (context, index) {
                  final item = displayItems[index];
                  return ArcoProductCard(
                    item: item,
                    onTap: () => BuildDrinkModal.show(context, item),
                  );
                },
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: displayItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: index == displayItems.length - 1 ? 0 : 20.0),
                      child: ArcoProductCard(
                        item: item,
                        variant: index == 0 ? ArcoCardVariant.featured : ArcoCardVariant.standard,
                        onTap: () => BuildDrinkModal.show(context, item),
                      ),
                    ),
                  );
                }).toList(),
              ),

            if (isMobile) ...[
              const SizedBox(height: 24),
              ArcoButton(
                text: "View Full Menu",
                onPressed: onExploreFullMenu,
                variant: ArcoButtonVariant.secondary,
                isFullWidth: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
