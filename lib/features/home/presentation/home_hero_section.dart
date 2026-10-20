import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_motion.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/models/menu_item.dart';
import '../../../shared/components/arco_arch.dart';
import '../../../shared/components/arco_text_link.dart';
import '../../../theme/theme_controller.dart';
import '../../court_card/presentation/drink_sheet.dart';

/// Signature Stage: one drink at a time, its name set enormous and thin behind
/// an arch-framed photograph under a court-light glow. The orange arc around
/// the arch doubles as the timer before the next signature drink takes the stage.
class HomeHeroSection extends StatefulWidget {
  final List<MenuItem> items;
  final VoidCallback onExploreMenu;

  const HomeHeroSection({super.key, required this.items, required this.onExploreMenu});

  @override
  State<HomeHeroSection> createState() => _HomeHeroSectionState();
}

class _HomeHeroSectionState extends State<HomeHeroSection> with TickerProviderStateMixin {
  // (menu item name, stage word)
  static const List<(String, String)> _stageSpec = [
    ('Spanish Latte', 'Spanish'),
    ('Mango Americano', 'Mango'),
    ('Milo Overload', 'Milo'),
    ('Haw-Haw Matcha', 'Matcha'),
  ];
  static const Duration _plateDuration = Duration(milliseconds: 6500);

  late final AnimationController _intro = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  late final AnimationController _plate = AnimationController(vsync: this, duration: _plateDuration);
  Timer? _advance;
  int _active = 0;

  List<(MenuItem, String)> get _stage => [
        for (final s in _stageSpec)
          for (final item in widget.items)
            if (item.name == s.$1) (item, s.$2),
      ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.isReducedMotion(context)) {
      _advance?.cancel();
      _plate.value = 1;
      _intro.value = 1;
    } else if (_intro.value == 0 && !_intro.isAnimating) {
      _intro.forward();
      _startPlate();
    }
  }

  void _startPlate() {
    _plate.forward(from: 0);
    _advance?.cancel();
    _advance = Timer(_plateDuration, () {
      final n = _stage.length;
      if (mounted && n > 0) _select((_active + 1) % n);
    });
  }

  void _select(int i) {
    setState(() => _active = i);
    if (!AppMotion.isReducedMotion(context)) _startPlate();
  }

  @override
  void dispose() {
    _advance?.cancel();
    _intro.dispose();
    _plate.dispose();
    super.dispose();
  }

  Widget _reveal(Widget child, double start) {
    final curve = CurvedAnimation(
      parent: _intro,
      curve: Interval(start, (start + 0.5).clamp(0.0, 1.0), curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: curve,
      child: child,
      builder: (context, child) => Opacity(
        opacity: curve.value,
        child: Transform.translate(offset: Offset(0, 24 * (1 - curve.value)), child: child),
      ),
    );
  }

  static String _fromPrice(MenuItem i) {
    final p = [i.hotPrice, i.price16oz, i.price].whereType<double>().reduce(math.min);
    return '₱${p.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final stage = _stage;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final pad = AppBreakpoints.horizontalPadding(context);

    if (stage.isEmpty) return SizedBox(height: isDesktop ? 760 : 900);
    final active = _active.clamp(0, stage.length - 1);
    final (item, word) = stage[active];

    return isDesktop ? _desktop(item, word, stage, width, pad) : _compact(item, word, stage, width, pad);
  }

  // ---------------------------------------------------------------- desktop

  Widget _desktop(MenuItem item, String word, List<(MenuItem, String)> stage, double width, double pad) {
    final theme = ThemeScope.of(context);
    final fs = (width * 0.17).clamp(120.0, 270.0);
    final archW = (width * 0.22).clamp(260.0, 330.0);
    final archH = archW * 1.38;
    const wordTop = 64.0;
    final archTop = wordTop + fs * 0.62;
    final height = archTop + archH + 120;
    final sideW = (width / 2 - archW / 2 - pad - 56).clamp(220.0, 400.0);
    // Side columns start below the stage word's baseline so they never collide with it.
    final sideTop = math.max(archTop + archH * 0.2, wordTop + fs * 0.98 + 24);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            top: 26,
            left: 0,
            right: 0,
            child: _reveal(_kicker(theme), 0),
          ),
          Positioned(top: wordTop, left: 0, right: 0, child: _reveal(_stageWord(word, fs, theme), 0.08)),
          // Vertical outlined wordmark along the right edge.
          Positioned(
            right: pad * 0.35,
            top: archTop - 10,
            child: RotatedBox(
              quarterTurns: 1,
              child: ArcoOutlineText('ARCOFFEE', fontSize: 92, color: theme.primaryText.withValues(alpha: 0.14)),
            ),
          ),
          Positioned(
            top: archTop - archW * 0.2,
            left: width / 2 - archW * 0.95,
            width: archW * 1.9,
            height: archH + archW * 0.4,
            child: _reveal(_stagePhoto(item, archW, archH), 0.18),
          ),
          Positioned(
            left: pad,
            top: sideTop,
            width: sideW,
            child: _reveal(_story(item, theme), 0.3),
          ),
          Positioned(
            right: pad + 96,
            top: sideTop,
            width: math.min(sideW, 280),
            child: _reveal(_specs(item, theme), 0.36),
          ),
          Positioned(
            left: pad,
            right: pad,
            bottom: 36,
            child: _reveal(_index(stage, theme), 0.44),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- phone / tablet

  Widget _compact(MenuItem item, String word, List<(MenuItem, String)> stage, double width, double pad) {
    final theme = ThemeScope.of(context);
    final fs = (width * 0.22).clamp(72.0, 170.0);
    final archW = (width * 0.56).clamp(200.0, 320.0);
    final archH = archW * 1.36;

    return Padding(
      padding: EdgeInsets.fromLTRB(pad, 24, pad, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _reveal(_kicker(theme), 0),
          const SizedBox(height: 12),
          SizedBox(
            height: fs * 0.62 + archH + archW * 0.1,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(top: 0, left: -pad, right: -pad, child: _reveal(_stageWord(word, fs, theme), 0.08)),
                Positioned(
                  top: fs * 0.62 - archW * 0.2,
                  left: (width - 2 * pad) / 2 - archW * 0.95,
                  width: archW * 1.9,
                  height: archH + archW * 0.4,
                  child: _reveal(_stagePhoto(item, archW, archH, sealSize: 84), 0.18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          _reveal(_story(item, theme), 0.3),
          const SizedBox(height: 32),
          _reveal(_specs(item, theme, horizontal: width >= 480), 0.36),
          const SizedBox(height: 32),
          _reveal(_index(stage, theme, compact: true), 0.44),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- pieces

  Widget _kicker(ThemeController theme) => Text(
        'POURED COURTSIDE  ·  THE PICKLEGROUND PH  ·  KAWIT, CAVITE',
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.scoreboard.copyWith(
          fontSize: 11,
          letterSpacing: 2.2,
          fontWeight: FontWeight.w700,
          color: AppColors.accentOrange,
        ),
      );

  Widget _stageWord(String word, double fs, ThemeController theme) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(anim),
          child: child,
        ),
      ),
      child: Text(
        word,
        key: ValueKey(word),
        textAlign: TextAlign.center,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.visible,
        style: AppTypography.displayXL.copyWith(
          fontSize: fs,
          height: 1,
          fontWeight: FontWeight.w200,
          fontVariations: const [FontVariation('wght', 200)],
          letterSpacing: -fs * 0.045,
          color: theme.primaryText,
        ),
      ),
    );
  }

  /// Arch photograph with its court-light glow, timer arc and seal. Box is archW*1.9 wide.
  Widget _stagePhoto(MenuItem item, double archW, double archH, {double sealSize = 112}) {
    return LayoutBuilder(
      builder: (context, box) {
        final cx = box.maxWidth / 2;
        final top = archW * 0.2;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Court-light glow behind the cup.
            Positioned(
              left: cx - archW * 0.95,
              top: top + archH * 0.05,
              width: archW * 1.9,
              height: archW * 1.9,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentOrange.withValues(alpha: 0.32),
                        AppColors.accentOrange.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Timer arc: hugs the arch head and fills while this drink holds the stage.
            Positioned(
              left: cx - archW / 2 - 18,
              top: top - 18,
              width: archW + 36,
              height: archW + 36,
              child: AnimatedBuilder(
                animation: _plate,
                builder: (context, _) => CustomPaint(
                  painter: ArcoArcStroke(
                    progress: _plate.value,
                    startAngle: math.pi,
                    sweep: math.pi,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
            Positioned(
              left: cx - archW / 2,
              top: top,
              width: archW,
              height: archH,
              child: Semantics(
                button: true,
                label: 'View ${item.name}',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => DrinkSheet.show(context, item),
                    child: ArcoArch(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        switchInCurve: Curves.easeOutCubic,
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 1.08, end: 1).animate(anim),
                            child: child,
                          ),
                        ),
                        layoutBuilder: (current, previous) => Stack(
                          fit: StackFit.expand,
                          children: [...previous, if (current != null) current],
                        ),
                        child: Image.asset(
                          item.imageAsset ?? 'assets/images/espresso_pour_latte.jpg',
                          key: ValueKey(item.id),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: cx + archW / 2 - sealSize * 0.55,
              top: top - sealSize * 0.1,
              child: ArcoSeal(
                text: "IT'S ALWAYS BEEN OURS  ·  ARCOFFEE  ·  ",
                size: sealSize,
                color: ThemeScope.of(context).primaryText,
                background: ThemeScope.of(context).scaffoldBackground,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _story(MenuItem item, ThemeController theme) {
    return AnimatedSwitcher(
      duration: AppMotion.emphasis,
      child: Column(
        key: ValueKey(item.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: AppTypography.headingXL.copyWith(
              fontSize: 26,
              height: 1.1,
              letterSpacing: -0.6,
              fontWeight: FontWeight.w800,
              color: theme.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.description,
            style: AppTypography.body.copyWith(fontSize: 15, height: 1.6, color: theme.secondaryText),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 24,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CourtCardSaveButton(item: item),
              ArcoTextLink(label: 'Full menu', color: theme.primaryText, onTap: widget.onExploreMenu),
            ],
          ),
        ],
      ),
    );
  }

  Widget _specs(MenuItem item, ThemeController theme, {bool horizontal = false}) {
    final rows = [
      ('SERIES', item.category.displayName),
      ('ENERGY', item.caffeineNote),
      ('SIZE', item.size),
    ];
    Widget row(int i) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentOrange, width: 1.2),
              ),
              child: Text(
                '0${i + 1}',
                style: AppTypography.scoreboard.copyWith(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.accentOrange),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rows[i].$1,
                    style: AppTypography.scoreboard.copyWith(
                      fontSize: 10,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w700,
                      color: theme.tertiaryText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    rows[i].$2,
                    style: AppTypography.body.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: theme.primaryText),
                  ),
                ],
              ),
            ),
          ],
        );

    final price = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FROM',
          style: AppTypography.scoreboard.copyWith(fontSize: 10, letterSpacing: 1.8, fontWeight: FontWeight.w700, color: theme.tertiaryText),
        ),
        Text(
          _fromPrice(item),
          style: AppTypography.displayXL.copyWith(
            fontSize: 44,
            height: 1.1,
            letterSpacing: -1.2,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
          ),
        ),
      ],
    );

    return AnimatedSwitcher(
      duration: AppMotion.emphasis,
      child: KeyedSubtree(
        key: ValueKey(item.id),
        child: horizontal
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < 3; i++) ...[if (i > 0) const SizedBox(width: 20), Expanded(child: row(i))],
                    ],
                  ),
                  const SizedBox(height: 24),
                  price,
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < 3; i++) ...[row(i), const SizedBox(height: 22)],
                  const SizedBox(height: 12),
                  Container(height: 1, color: theme.borderLight),
                  const SizedBox(height: 16),
                  price,
                ],
              ),
      ),
    );
  }

  Widget _index(List<(MenuItem, String)> stage, ThemeController theme, {bool compact = false}) {
    return Row(
      children: [
        for (var i = 0; i < stage.length; i++)
          Expanded(
            child: Semantics(
              button: true,
              selected: i == _active,
              label: 'Show ${stage[i].$1.name}',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _select(i),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 44),
                    child: Padding(
                      padding: EdgeInsets.only(right: i == stage.length - 1 ? 0 : 16, top: 6),
                      child: AnimatedOpacity(
                        duration: AppMotion.standard,
                        opacity: i == _active ? 1 : 0.45,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 1, color: i == _active ? AppColors.accentOrange : theme.borderLight),
                            const SizedBox(height: 10),
                            Text(
                              compact ? '0${i + 1}' : '0${i + 1}   ${stage[i].$1.name.toUpperCase()}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.scoreboard.copyWith(
                                fontSize: 11,
                                letterSpacing: 1.4,
                                fontWeight: FontWeight.w700,
                                color: i == _active ? AppColors.accentOrange : theme.primaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
