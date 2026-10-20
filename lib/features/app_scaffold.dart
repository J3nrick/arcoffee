import 'package:flutter/cupertino.dart';
import '../core/design/app_breakpoints.dart';
import '../data/models/menu_item.dart';
import '../data/repositories/gallery_repository.dart';
import '../data/repositories/menu_repository.dart';
import '../data/repositories/store_repository.dart';
import '../data/services/court_card_service.dart';
import '../shared/components/arco_footer.dart';
import '../shared/components/arco_navigation.dart';
import '../theme/theme_controller.dart';
import 'error/presentation/out_of_bounds_view.dart';
import 'gallery/presentation/gallery_view.dart';
import 'home/presentation/home_hero_section.dart';
import 'home/presentation/home_sections.dart';
import 'location/presentation/location_view.dart';
import 'menu/presentation/menu_view.dart';
import 'court_card/presentation/court_card_sheet.dart';

/// Main application orchestrator for Arcoffee ("Court-side coffee culture").
class AppScaffold extends StatefulWidget {
  final MenuRepository menuRepository;
  final StoreRepository storeRepository;
  final GalleryRepository galleryRepository;
  final int initialTabIndex;

  const AppScaffold({
    super.key,
    required this.menuRepository,
    required this.storeRepository,
    required this.galleryRepository,
    this.initialTabIndex = 0,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late int _currentTabIndex;
  final ScrollController _scrollController = ScrollController();
  List<MenuItem> _featuredItems = [];
  List<MenuItem> _menuItems = [];
  bool? _isOpen;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex;
    _loadFeatured();
    widget.storeRepository.isStoreOpenCurrently().then((open) {
      if (mounted) setState(() => _isOpen = open);
    });
  }

  Future<void> _loadFeatured() async {
    final featured = await widget.menuRepository.getFeaturedItems();
    final all = await widget.menuRepository.getMenuItems();
    if (!mounted) return;
    CourtCardService.instance.restore(all);
    setState(() {
      _featuredItems = featured;
      _menuItems = all;
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

  void _openCourtCard() {
    CourtCardSheet.show(context, onBrowseMenu: () => _onTabSelected(1));
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isMobile = AppBreakpoints.isMobile(context);

    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackground,
      child: Column(
        children: [
          ArcoNavigation(
            selectedIndex: _currentTabIndex,
            onTabSelected: _onTabSelected,
            onCourtCardPressed: _openCourtCard,
            scrollController: _scrollController,
            isOpen: _isOpen,
          ),

          // Scrollable View Content
          Expanded(
            child: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildCurrentViewBody(),
                    ),
                    SliverToBoxAdapter(
                      child: ArcoFooter(
                        onNavigate: _onTabSelected,
                        showJoin: _currentTabIndex != 0,
                      ),
                    ),
                    // Room for the floating Court Card capsule.
                    if (isMobile) const SliverToBoxAdapter(child: SizedBox(height: 88)),
                  ],
                ),
                // Phones: one floating Court Card capsule instead of a tab bar.
                if (isMobile)
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 16 + MediaQuery.paddingOf(context).bottom,
                    child: ArcoCourtCardButton(onPressed: _openCourtCard, expanded: true),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentViewBody() {
    switch (_currentTabIndex) {
      case 0:
        return Column(
          children: [
            HomeHeroSection(items: _menuItems, onExploreMenu: () => _onTabSelected(1)),
            HomeNumbersSection(drinkCount: _menuItems.length),
            HomeStorySection(onOpenCourtCard: _openCourtCard),
            HomeShopSection(items: _featuredItems, onExploreFullMenu: () => _onTabSelected(1)),
            GalleryView(repository: widget.galleryRepository),
            LocationView(repository: widget.storeRepository),
            const HomeJoinSection(),
          ],
        );
      case 1:
        return MenuView(repository: widget.menuRepository);
      case 2:
        return GalleryView(repository: widget.galleryRepository, standalone: true);
      case 3:
        return LocationView(repository: widget.storeRepository, standalone: true);
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
}
