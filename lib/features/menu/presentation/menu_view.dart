import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_motion.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/models/menu_item.dart';
import '../../../data/repositories/menu_repository.dart';
import '../../../shared/components/arco_in_view.dart';
import '../../../shared/components/arco_lightbox.dart';
import '../../../shared/components/arco_page_cover.dart';
import '../../../shared/components/arco_text_link.dart';
import '../../../theme/theme_controller.dart';
import '../../court_card/presentation/drink_sheet.dart';

/// Editorial Menu: photographic cover, typographic category index,
/// photo-led drink plates, and a printed add-ons price list.
class MenuView extends StatefulWidget {
  final MenuRepository repository;

  const MenuView({super.key, required this.repository});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  MenuCategory _selectedCategory = MenuCategory.all;
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

  List<MenuItem> get _filteredItems => _selectedCategory == MenuCategory.all
      ? _allItems
      : _allItems.where((item) => item.category == _selectedCategory).toList();

  int _countFor(MenuCategory cat) =>
      cat == MenuCategory.all ? _allItems.length : _allItems.where((i) => i.category == cat).length;

  void _showMenuBoard() => showArcoLightbox(
        context,
        asset: 'assets/images/menu_board.png',
        title: 'OFFICIAL PRINTED MENU BOARD  ·  THE PICKLEGROUND PH, KAWIT',
      );

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final pad = AppBreakpoints.horizontalPadding(context);
    final isMobile = AppBreakpoints.isMobile(context);

    return Column(
      children: [
        ArcoPageCover(
          index: 'AR / 002',
          kicker: 'CRAFT MENU  ·  SEASON 2026  ·  POURED COURTSIDE',
          title: 'THE\nMENU.',
          lede: 'Espresso pulled between rallies, overloads built for the post-game, and sodas cold enough to reset a tiebreak.',
          imageAsset: 'assets/images/espresso_pour_latte.jpg',
          caption: 'PLATE — ICED LATTE POUR, BAR COUNTER',
          actions: [
            ArcoTextLink(label: 'View the printed board', onTap: _showMenuBoard),
          ],
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(pad, isMobile ? 40 : 72, pad, isMobile ? 48 : 96),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
            child: _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CupertinoActivityIndicator(radius: 14)),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryIndex(theme),
                      SizedBox(height: isMobile ? 36 : 56),
                      _buildPlates(),
                      SizedBox(height: isMobile ? 64 : 112),
                      _buildAddOns(theme),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  /// Typographic category index: large set names with counts, no chips.
  Widget _buildCategoryIndex(ThemeController theme) {
    final isMobile = AppBreakpoints.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: MenuCategory.values.map((cat) {
              final selected = cat == _selectedCategory;
              return Padding(
                padding: EdgeInsets.only(right: isMobile ? 24 : 40),
                child: Semantics(
                  button: true,
                  selected: selected,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 44),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: AppMotion.standard,
                                  style: AppTypography.display.copyWith(
                                    fontSize: isMobile ? 22 : 30,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.8,
                                    color: selected ? theme.primaryText : theme.tertiaryText.withValues(alpha: 0.6),
                                  ),
                                  child: Text(cat == MenuCategory.all ? 'Everything' : cat.displayName),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _countFor(cat).toString().padLeft(2, '0'),
                                  style: AppTypography.scoreboard.copyWith(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: selected ? AppColors.accentOrange : theme.tertiaryText,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            AnimatedContainer(
                              duration: AppMotion.emphasis,
                              curve: AppMotion.defaultCurve,
                              height: 2,
                              width: selected ? 32 : 0,
                              color: AppColors.accentOrange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 18),
        Container(height: 1, color: theme.borderLight),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: AppMotion.standard,
          child: Text(
            '${_selectedCategory.description.toUpperCase()}  ·  ${_filteredItems.length} DRINKS',
            key: ValueKey(_selectedCategory),
            style: AppTypography.scoreboard.copyWith(
              fontSize: 11,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w700,
              color: theme.secondaryText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlates() {
    final items = _filteredItems;
    final cols = AppBreakpoints.isDesktop(context) ? 3 : (AppBreakpoints.isMobile(context) ? 1 : 2);
    const gap = 32.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - gap * (cols - 1)) / cols;
        return Wrap(
          key: ValueKey(_selectedCategory),
          spacing: gap,
          runSpacing: cols == 1 ? 48 : 64,
          children: [
            for (var i = 0; i < items.length; i++)
              SizedBox(
                width: width,
                child: ArcoInView(
                  delay: Duration(milliseconds: 90 * (i % cols)),
                  child: _MenuPlate(
                    item: items[i],
                    number: i + 1,
                    landscape: cols == 1,
                    onTap: () => DrinkSheet.show(context, items[i]),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Printed price list with hairline leaders, like the board at the bar.
  Widget _buildAddOns(ThemeController theme) {
    final isDesktop = AppBreakpoints.isDesktop(context);
    final list = Column(
      children: barAddOns.map((a) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(a.$1, style: AppTypography.bodyLarge.copyWith(fontSize: 17, fontWeight: FontWeight.w600, color: theme.primaryText)),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                  height: 1,
                  color: theme.borderLight,
                ),
              ),
              Text(a.$2, style: AppTypography.scoreboard.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.accentOrange)),
            ],
          ),
        );
      }).toList(),
    );
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AR / 002.1  ·  ADD-ONS',
          style: AppTypography.scoreboard.copyWith(
            fontSize: 11,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w700,
            color: AppColors.accentOrange,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Make it\nyours.',
          style: AppTypography.displayXL.copyWith(
            fontSize: isDesktop ? 64 : 44,
            height: 0.92,
            letterSpacing: -2,
            fontWeight: FontWeight.w900,
            color: theme.primaryText,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Every drink is made fresh at the bar. Ask for any of these when you get there.',
          style: AppTypography.body.copyWith(color: theme.secondaryText, height: 1.55),
        ),
      ],
    );
    return ArcoInView(
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: heading),
                const SizedBox(width: 96),
                Expanded(flex: 6, child: list),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [heading, const SizedBox(height: 28), list],
            ),
    );
  }
}

/// A single drink as an editorial plate: photograph, index metadata, name, note, price.
class _MenuPlate extends StatefulWidget {
  final MenuItem item;
  final int number;
  final bool landscape;
  final VoidCallback onTap;

  const _MenuPlate({required this.item, required this.number, required this.landscape, required this.onTap});

  @override
  State<_MenuPlate> createState() => _MenuPlateState();
}

class _MenuPlateState extends State<_MenuPlate> {
  bool _hover = false;

  String? get _flag {
    final i = widget.item;
    if (i.isBestseller) return 'BESTSELLER';
    if (i.isSignature) return 'SIGNATURE';
    if (i.isCourtFavorite) return 'COURT FAVORITE';
    if (i.isNew) return 'NEW';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final item = widget.item;
    final meta = AppTypography.scoreboard.copyWith(fontSize: 10.5, letterSpacing: 1.6, fontWeight: FontWeight.w700);

    return Semantics(
      button: true,
      label: '${item.name}, ${item.displayPrice}. View details.',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AspectRatio(
                  aspectRatio: widget.landscape ? 5 / 4 : 4 / 5,
                  child: ColoredBox(
                    color: theme.borderLight,
                    child: AnimatedScale(
                      scale: _hover ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      child: item.imageAsset != null
                          ? Image.asset(item.imageAsset!, fit: BoxFit.cover)
                          : const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(widget.number.toString().padLeft(2, '0'), style: meta.copyWith(color: AppColors.accentOrange)),
                  const SizedBox(width: 12),
                  Text(item.category.displayName.toUpperCase(), style: meta.copyWith(color: theme.tertiaryText)),
                  const Spacer(),
                  if (_flag != null) Text(_flag!, style: meta.copyWith(color: AppColors.accentOrange)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item.name,
                style: AppTypography.display.copyWith(
                  fontSize: 28,
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  color: theme.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(fontSize: 14, height: 1.5, color: theme.secondaryText),
              ),
              const SizedBox(height: 16),
              Container(height: 1, color: theme.borderLight),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.displayPrice,
                      style: AppTypography.scoreboard.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: theme.primaryText,
                      ),
                    ),
                  ),
                  AnimatedSlide(
                    offset: Offset(_hover ? 0.12 : 0, 0),
                    duration: AppMotion.emphasis,
                    curve: AppMotion.defaultCurve,
                    child: Text(
                      'Details →',
                      style: AppTypography.body.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _hover ? AppColors.accentOrange : theme.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
