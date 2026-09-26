import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/models/menu_item.dart';
import '../../../data/repositories/menu_repository.dart';
import '../../../shared/components/arco_category_selector.dart';
import '../../../shared/components/arco_product_card.dart';
import '../../../shared/components/arco_sticker.dart';
import '../../../theme/theme_controller.dart';
import 'widgets/build_drink_modal.dart';

/// Editorial Menu View for Arcoffee ("Court-side coffee culture").
class MenuView extends StatefulWidget {
  final MenuRepository repository;

  const MenuView({super.key, required this.repository});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  MenuCategory _selectedCategory = MenuCategory.coffee;
  List<MenuItem> _allItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenuData();
  }

  Future<void> _loadMenuData() async {
    final items = await widget.repository.getMenuItems();
    if (!mounted) return;
    setState(() {
      _allItems = items;
      _isLoading = false;
    });
  }

  List<MenuItem> get _filteredItems {
    return _allItems.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
    final horizontalPad = AppBreakpoints.horizontalPadding(context);

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: CupertinoActivityIndicator(radius: 16),
        ),
      );
    }

    final items = _filteredItems;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 36),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ArcoSticker(text: "CRAFT MENU", rotation: -0.01),
                    const SizedBox(height: 8),
                    Text(
                      "Craft Drink Selection",
                      style: AppTypography.display.copyWith(
                        color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                        fontSize: isMobile ? 28 : 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Horizontal Category Selector
            ArcoCategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (cat) {
                setState(() => _selectedCategory = cat);
              },
            ),
            const SizedBox(height: 32),

            // Items Grid (Asymmetric & Responsive)
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(48.0),
                child: Center(
                  child: Text(
                    "No items found in this category.",
                    style: AppTypography.bodyLarge,
                  ),
                ),
              )
            else if (isMobile)
              Column(
                children: items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ArcoProductCard(
                      item: item,
                      onTap: () => BuildDrinkModal.show(context, item),
                    ),
                  );
                }).toList(),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 2 : 3,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: isTablet ? 0.74 : 0.72,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ArcoProductCard(
                    item: item,
                    variant: (index == 0 && !isMobile)
                        ? ArcoCardVariant.featured
                        : ArcoCardVariant.standard,
                    onTap: () => BuildDrinkModal.show(context, item),
                  );
                },
              ),
            const SizedBox(height: 36),

            // Official Menu Board Add-ons Strip
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withValues(alpha: 0.1),
                ),
              ),
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "OFFICIAL ADD-ONS",
                          style: AppTypography.scoreboard.copyWith(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentOrange,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Extra Espresso +₱30  •  Substitute Oat Milk +₱40  •  Sweetened Milk +₱15",
                          style: AppTypography.receipt.copyWith(
                            fontSize: 11,
                            letterSpacing: 0.5,
                            color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "OFFICIAL ADD-ONS",
                          style: AppTypography.scoreboard.copyWith(
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentOrange,
                          ),
                        ),
                        Text(
                          "Extra Espresso +₱30   •   Substitute Oat Milk +₱40   •   Sweetened Milk +₱15",
                          style: AppTypography.receipt.copyWith(
                            fontSize: 11,
                            letterSpacing: 0.6,
                            color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
