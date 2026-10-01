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
/// Showcases authentic drinks, category filtering, search, and official printed menu board lightbox.
class MenuView extends StatefulWidget {
  final MenuRepository repository;

  const MenuView({super.key, required this.repository});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  MenuCategory _selectedCategory = MenuCategory.all;
  List<MenuItem> _allItems = [];
  final String _searchQuery = '';
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
    return _allItems.where((item) {
      final matchesCategory = _selectedCategory == MenuCategory.all || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showMenuBoardLightbox(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return Container(
          color: AppColors.deepBlue.withValues(alpha: 0.95),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    maxScale: 4.0,
                    child: Image.asset(
                      'assets/images/menu_board.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: CupertinoButton(
                    color: AppColors.accentOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      "CLOSE ✕",
                      style: TextStyle(
                        fontFamily: AppTypography.displayFont,
                        fontWeight: FontWeight.w800,
                        color: AppColors.pureWhite,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: AppColors.deepBlue.withValues(alpha: 0.8),
                    child: const Text(
                      "OFFICIAL PRINTED MENU BOARD • THE PICKLEGROUND PH, KAWIT, CAVITE",
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        fontFamilyFallback: AppTypography.monoFontFallback,
                        fontSize: 11,
                        color: AppColors.pureWhite,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
            // Header Row with Title & "View Menu Board" action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ArcoSticker(text: "CRAFT MENU • 2026", rotation: -0.01),
                      const SizedBox(height: 8),
                      Text(
                        "Craft Drink Selection",
                        style: AppTypography.display.copyWith(
                          color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                          fontSize: isMobile ? 28 : 38,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMobile)
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: isDark ? const Color(0xFF16283C) : AppColors.deepBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                    onPressed: () => _showMenuBoardLightbox(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(CupertinoIcons.doc_text_viewfinder, size: 16, color: AppColors.accentOrange),
                        const SizedBox(width: 8),
                        Text(
                          "View Printed Menu Board",
                          style: TextStyle(
                            fontFamily: AppTypography.displayFont,
                            fontFamilyFallback: AppTypography.displayFontFallback,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.pureWhite : AppColors.deepBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (isMobile) ...[
              const SizedBox(height: 14),
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: isDark ? const Color(0xFF16283C) : AppColors.deepBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
                onPressed: () => _showMenuBoardLightbox(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.doc_text_viewfinder, size: 15, color: AppColors.accentOrange),
                    const SizedBox(width: 6),
                    Text(
                      "View Printed Menu Board",
                      style: TextStyle(
                        fontFamily: AppTypography.displayFont,
                        fontFamilyFallback: AppTypography.displayFontFallback,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.pureWhite : AppColors.deepBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Horizontal Category Selector
            ArcoCategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (cat) {
                setState(() => _selectedCategory = cat);
              },
            ),
            const SizedBox(height: 32),

            // Items Grid with Large 180px Photo Headers
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 64.0, horizontal: 24.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "No drinks found in this line-up.",
                        style: AppTypography.heading.copyWith(
                          color: isDark ? AppColors.pureWhite : AppColors.deepBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Try switching categories or clearing search to find your match.",
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.02),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<String>('menu_${_selectedCategory.name}_${items.length}'),
                  child: isMobile
                      ? Column(
                          children: items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: SizedBox(
                                height: 340,
                                child: ArcoProductCard(
                                  item: item,
                                  onTap: () => BuildDrinkModal.show(context, item),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet ? 2 : 3,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            childAspectRatio: isTablet ? 0.65 : 0.62,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return ArcoProductCard(
                              item: item,
                              variant: (index == 0 && !isMobile && _selectedCategory == MenuCategory.all)
                                  ? ArcoCardVariant.featured
                                  : ArcoCardVariant.standard,
                              onTap: () => BuildDrinkModal.show(context, item),
                            );
                          },
                        ),
                ),
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
                          "Extra Espresso +₱30  •  Substitute Oat Milk +₱40  •  Sweetened Milk +₱15  •  Haw-Haw Cold Foam +₱40  •  Malt Overload +₱25",
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
                          "Extra Espresso +₱30   •   Substitute Oat Milk +₱40   •   Sweetened Milk +₱15   •   Haw-Haw Foam +₱40   •   Malt Overload +₱25",
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
