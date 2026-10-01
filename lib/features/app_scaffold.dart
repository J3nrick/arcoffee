import 'package:flutter/cupertino.dart';
import '../core/design/app_breakpoints.dart';
import '../core/design/app_colors.dart';
import '../core/design/app_typography.dart';
import '../data/models/menu_item.dart';
import '../data/repositories/gallery_repository.dart';
import '../data/repositories/menu_repository.dart';
import '../data/repositories/store_repository.dart';
import '../data/services/order_tray_service.dart';
import '../shared/components/arco_footer.dart';
import '../shared/components/arco_navigation.dart';
import '../theme/theme_controller.dart';
import 'error/presentation/out_of_bounds_view.dart';
import 'gallery/presentation/gallery_view.dart';
import 'home/presentation/home_hero_section.dart';
import 'home/presentation/home_highlights_section.dart';
import 'location/presentation/location_view.dart';
import 'menu/presentation/menu_view.dart';
import 'order/presentation/court_side_delivery_modal.dart';

/// Main application orchestrator for Arcoffee ("Court-side coffee culture").
class AppScaffold extends StatefulWidget {
  final MenuRepository menuRepository;
  final StoreRepository storeRepository;
  final GalleryRepository galleryRepository;
  final int initialTabIndex;
  final String? preselectedCourt;

  const AppScaffold({
    super.key,
    required this.menuRepository,
    required this.storeRepository,
    required this.galleryRepository,
    this.initialTabIndex = 0,
    this.preselectedCourt,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late int _currentTabIndex;
  final ScrollController _scrollController = ScrollController();
  List<MenuItem> _featuredItems = [];

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex;
    if (widget.preselectedCourt != null && widget.preselectedCourt!.isNotEmpty) {
      OrderTrayService.instance.setCourtNumber(widget.preselectedCourt!);
    }
    _loadFeatured();
  }

  Future<void> _loadFeatured() async {
    final items = await widget.menuRepository.getFeaturedItems();
    if (!mounted) return;
    setState(() {
      _featuredItems = items;
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentTabIndex = index;
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openOrderModal() {
    CourtSideDeliveryModal.show(
      context,
      onExploreMenu: () => _onTabSelected(1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isMobile = AppBreakpoints.isMobile(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackground,
      child: Column(
        children: [
          // Floating Centered ArcoNavigation
          ArcoNavigation(
            selectedIndex: _currentTabIndex,
            onTabSelected: _onTabSelected,
            onOrderPressed: _openOrderModal,
          ),

          // Scrollable View Content
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildCurrentViewBody(),
                ),
                SliverToBoxAdapter(
                  child: ArcoFooter(
                    onNavigate: _onTabSelected,
                  ),
                ),
              ],
            ),
          ),

          // Compact Mobile Bottom Bar
          if (isMobile) _buildMobileBottomBar(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildCurrentViewBody() {
    switch (_currentTabIndex) {
      case 0:
        // Complete Editorial Brand Journey matching ASCII Structural Blueprint
        return Column(
          children: [
            // AR / 001: Asymmetrical Hero Section
            HomeHeroSection(
              onExploreMenu: () => _onTabSelected(1),
              onViewLocation: () => _onTabSelected(3),
            ),
            // AR / 002: Signature Drinks Editorial Showcase
            HomeHighlightsSection(
              featuredItems: _featuredItems,
              onExploreFullMenu: () => _onTabSelected(1),
            ),
            // AR / 003: The Arcoffee Wall (Editorial Collage)
            GalleryView(repository: widget.galleryRepository),
            // AR / 004: Find Us At The Court
            LocationView(repository: widget.storeRepository),
          ],
        );
      case 1:
        return MenuView(repository: widget.menuRepository);
      case 2:
        return GalleryView(repository: widget.galleryRepository);
      case 3:
        return LocationView(repository: widget.storeRepository);
      case 4:
        return OutOfBoundsView(
          onReturnToMenu: () => _onTabSelected(1),
          onReturnHome: () => _onTabSelected(0),
        );
      default:
        return OutOfBoundsView(
          onReturnToMenu: () => _onTabSelected(1),
          onReturnHome: () => _onTabSelected(0),
        );
    }
  }

  Widget _buildMobileBottomBar(ThemeController theme, bool isDark) {
    final tray = OrderTrayService.instance;

    return Container(
      decoration: BoxDecoration(
        color: theme.glassBackground,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withValues(alpha: 0.08),
            width: 0.8,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _mobileNavButton(0, CupertinoIcons.house_fill, "Home", theme, isDark),
              _mobileNavButton(1, CupertinoIcons.circle_grid_hex_fill, "Menu", theme, isDark),
              _mobileDeliveryButton(theme, isDark, tray),
              _mobileNavButton(2, CupertinoIcons.person_3_fill, "Wall", theme, isDark),
              _mobileNavButton(3, CupertinoIcons.location_fill, "Visit", theme, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mobileDeliveryButton(ThemeController theme, bool isDark, OrderTrayService tray) {
    return AnimatedBuilder(
      animation: tray,
      builder: (context, _) {
        final count = tray.itemCount;

        return CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          minimumSize: const Size(44, 44),
          onPressed: _openOrderModal,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange,
                      shape: BoxShape.circle,
                      boxShadow: theme.glowingOrangeShadow,
                    ),
                    child: const Icon(
                      CupertinoIcons.paperplane_fill,
                      size: 16,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Order",
                    style: TextStyle(
                      fontFamily: AppTypography.displayFont,
                      fontFamilyFallback: AppTypography.displayFontFallback,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                      color: AppColors.accentOrange,
                    ),
                  ),
                ],
              ),
              if (count > 0)
                Positioned(
                  top: -2,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF34C759),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$count",
                      style: const TextStyle(
                        fontFamily: AppTypography.monoFont,
                        fontFamilyFallback: AppTypography.monoFontFallback,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _mobileNavButton(int index, IconData icon, String label, ThemeController theme, bool isDark) {
    final isSelected = _currentTabIndex == index;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      minimumSize: const Size(44, 44),
      onPressed: () => _onTabSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected
                ? AppColors.accentOrange
                : (isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              fontFamilyFallback: AppTypography.displayFontFallback,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              letterSpacing: 0.2,
              color: isSelected
                  ? AppColors.accentOrange
                  : (isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay),
            ),
          ),
        ],
      ),
    );
  }
}
