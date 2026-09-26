import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/state/view_state.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/menu_item.dart';
import '../../../data/repositories/menu_repository.dart';
import '../../../shared/widgets/apple_alert.dart';
import '../../../shared/widgets/badge_pill.dart';
import 'controllers/menu_controller.dart';
import 'widgets/menu_card.dart';
import 'widgets/build_drink_modal.dart';

/// Production-ready Menu View with explicit state management,
/// Apple HIG error handling, and responsive controls.
class MenuView extends StatefulWidget {
  final MenuRepository repository;

  const MenuView({super.key, required this.repository});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  late final MenuViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MenuViewController(repository: widget.repository);
    _controller.loadMenu();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    if (_controller.state.isError) {
      AppleAlert.showError(
        context: context,
        title: 'Menu Unavailable',
        message: _controller.state.errorMessage ?? 'Unable to fetch drinks from Arcoffee servers.',
        onRetry: () => _controller.retry(),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);
    final state = _controller.state;
    final items = _controller.filteredItems;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            const BadgePill(
              label: "ARCOFFEE CRAFT MENU",
              icon: CupertinoIcons.sparkles,
              backgroundColor: Color(0xFFFFEAD9),
              textColor: AppColors.accentOrange,
            ),
            const SizedBox(height: 8),
            Text(
              "Curated Drinks & Series",
              style: AppTypography.title1.copyWith(
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Freshly pulled espresso, rich signature milks, sparkling sodas, and ceremonial Uji matcha.",
              style: AppTypography.callout.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Controls Row: Responsive Segmented Control + Search
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildScrollableSegmentedControl(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: _buildScrollableSegmentedControl(),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 4,
                    child: _buildSearchBar(),
                  ),
                ],
              ),

            const SizedBox(height: 28),

            // Category Info Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _controller.selectedCategory.icon,
                      size: 18,
                      color: AppColors.accentOrange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _controller.selectedCategory.displayName,
                      style: AppTypography.headline.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "• ${_controller.selectedCategory.description}",
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${items.length} items",
                  style: AppTypography.caption1.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Content according to State
            _buildStateBody(state, items),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableSegmentedControl() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(3),
        child: CupertinoSlidingSegmentedControl<MenuCategory>(
          backgroundColor: CupertinoColors.transparent,
          thumbColor: AppColors.pureWhite,
          groupValue: _controller.selectedCategory,
          onValueChanged: (cat) {
            if (cat != null) _controller.selectCategory(cat);
          },
          children: {
            MenuCategory.all: _segmentLabel("All", MenuCategory.all),
            MenuCategory.coffee: _segmentLabel("Coffee", MenuCategory.coffee),
            MenuCategory.nonCoffee: _segmentLabel("Non-Coffee", MenuCategory.nonCoffee),
            MenuCategory.soda: _segmentLabel("Soda Series", MenuCategory.soda),
            MenuCategory.matcha: _segmentLabel("Matcha", MenuCategory.matcha),
          },
        ),
      ),
    );
  }

  Widget _segmentLabel(String label, MenuCategory category) {
    final isSelected = _controller.selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.accentOrange : AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSearchBar() {
    return CupertinoSearchTextField(
      placeholder: 'Search drinks, notes, ingredients...',
      backgroundColor: AppColors.pureWhite.withOpacity(0.85),
      borderRadius: BorderRadius.circular(12),
      itemColor: AppColors.textSecondary,
      style: AppTypography.callout.copyWith(
        color: AppColors.textPrimary,
        fontSize: 14,
      ),
      onChanged: (val) => _controller.setSearchQuery(val),
    );
  }

  Widget _buildStateBody(ViewState<List<MenuItem>> state, List<MenuItem> items) {
    if (state.isLoading && (state.data == null || state.data!.isEmpty)) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80.0),
          child: Column(
            children: [
              CupertinoActivityIndicator(radius: 18),
              SizedBox(height: 14),
              Text(
                "Pulling fresh menu items...",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isError && (state.data == null || state.data!.isEmpty)) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Icon(
                CupertinoIcons.wifi_exclamationmark,
                size: 52,
                color: AppColors.accentOrange,
              ),
              const SizedBox(height: 14),
              Text(
                "Unable to Load Menu",
                style: AppTypography.headline.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                state.errorMessage ?? 'Network request failed. Please check your connection.',
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CupertinoButton.filled(
                borderRadius: BorderRadius.circular(14),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                onPressed: () => _controller.retry(),
                child: const Text(
                  "Retry",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.pureWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Icon(
                CupertinoIcons.search,
                size: 48,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 12),
              Text(
                "No drinks found",
                style: AppTypography.headline.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Try searching for another keyword or change categories.",
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _buildMenuGrid(items);
  }

  Widget _buildMenuGrid(List<MenuItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columns = 1;
        if (width >= 1380) {
          columns = 4;
        } else if (width >= 1040) {
          columns = 3;
        } else if (width >= 680) {
          columns = 2;
        }

        final totalSpacing = (columns - 1) * 16.0;
        final itemWidth = (width - totalSpacing) / columns;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items.map((item) {
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
}
