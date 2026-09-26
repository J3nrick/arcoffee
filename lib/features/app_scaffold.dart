import 'package:flutter/cupertino.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/responsive.dart';
import '../theme/theme_controller.dart';
import '../data/models/menu_item.dart';
import '../data/repositories/gallery_repository.dart';
import '../data/repositories/menu_repository.dart';
import '../data/repositories/store_repository.dart';
import '../shared/widgets/cupertino_nav_bar.dart';
import '../shared/widgets/footer_view.dart';
import '../shared/widgets/macos_window_frame.dart';
import 'gallery/presentation/gallery_view.dart';
import 'home/presentation/home_highlights_section.dart';
import 'home/presentation/home_hero_section.dart';
import 'location/presentation/location_view.dart';
import 'menu/presentation/menu_view.dart';

/// Main application orchestrator binding the Cupertino HIG navigation,
/// responsive macOS window frame, and view routing.
class AppScaffold extends StatefulWidget {
  final MenuRepository menuRepository;
  final StoreRepository storeRepository;
  final GalleryRepository galleryRepository;

  const AppScaffold({
    super.key,
    required this.menuRepository,
    required this.storeRepository,
    required this.galleryRepository,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _currentTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  List<MenuItem> _featuredItems = [];

  @override
  void initState() {
    super.initState();
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
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackground,
      child: MacOSWindowFrame(
        activeIndex: _currentTabIndex,
        onTabSelected: _onTabSelected,
        child: Column(
          children: [
            // Top Frosted Glass Navigation Bar
            CupertinoCustomNavBar(
              selectedIndex: _currentTabIndex,
              onTabSelected: _onTabSelected,
              onActionPressed: () => _onTabSelected(1), // Go to menu
            ),

            // Scrollable Content Body
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildCurrentViewBody(),
                  ),
                  SliverToBoxAdapter(
                    child: FooterView(
                      onNavigate: _onTabSelected,
                    ),
                  ),
                ],
              ),
            ),

            // Mobile Bottom Navigation Bar (Apple HIG iOS pattern)
            if (isMobile) _buildMobileBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentViewBody() {
    Widget content;
    switch (_currentTabIndex) {
      case 0:
        content = Column(
          key: const ValueKey<int>(0),
          children: [
            HomeHeroSection(
              onExploreMenu: () => _onTabSelected(1),
              onViewLocation: () => _onTabSelected(3),
            ),
            HomeHighlightsSection(
              featuredItems: _featuredItems,
              onExploreFullMenu: () => _onTabSelected(1),
            ),
          ],
        );
        break;
      case 1:
        content = KeyedSubtree(
          key: const ValueKey<int>(1),
          child: MenuView(repository: widget.menuRepository),
        );
        break;
      case 2:
        content = KeyedSubtree(
          key: const ValueKey<int>(2),
          child: GalleryView(repository: widget.galleryRepository),
        );
        break;
      case 3:
        content = KeyedSubtree(
          key: const ValueKey<int>(3),
          child: LocationView(repository: widget.storeRepository),
        );
        break;
      default:
        content = const SizedBox.shrink();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
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
      child: content,
    );
  }

  Widget _buildMobileBottomBar(ThemeController theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.glassBackground,
        border: Border(
          top: BorderSide(color: theme.borderLight, width: 0.8),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _mobileNavButton(0, CupertinoIcons.house_fill, "Home", theme),
          _mobileNavButton(1, CupertinoIcons.circle_grid_hex_fill, "Menu", theme),
          _mobileNavButton(2, CupertinoIcons.person_3_fill, "Community", theme),
          _mobileNavButton(3, CupertinoIcons.location_fill, "Location", theme),
        ],
      ),
    );
  }

  Widget _mobileNavButton(int index, IconData icon, String label, ThemeController theme) {
    final isSelected = _currentTabIndex == index;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      minSize: 40,
      onPressed: () => _onTabSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected ? AppColors.accentOrange : theme.secondaryText,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.accentOrange : theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
