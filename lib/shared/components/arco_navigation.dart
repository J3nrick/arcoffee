import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/design/app_breakpoints.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_typography.dart';
import '../../data/services/court_card_service.dart';
import '../../theme/theme_controller.dart';

const List<String> _navLabels = ['Home', 'Menu', 'Community', 'Visit'];

/// The clubhouse masthead.
///
/// Desktop: a thin utility strip (live court status, venue, Kawit local time,
/// Day / Night switch) over the main bar (logo, numbered links with an orange
/// underline that slides between them, Court Card). Once the page scrolls
/// the strip folds away and the bar tightens under a hairline.
///
/// Phone and tablet: logo plus a Menu control that opens a full-screen night menu.
class ArcoNavigation extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onCourtCardPressed;
  final ScrollController? scrollController;
  final bool? isOpen;

  const ArcoNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onCourtCardPressed,
    this.scrollController,
    this.isOpen,
  });

  @override
  State<ArcoNavigation> createState() => _ArcoNavigationState();
}

class _ArcoNavigationState extends State<ArcoNavigation> {
  bool _condensed = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ArcoNavigation old) {
    super.didUpdateWidget(old);
    if (old.scrollController != widget.scrollController) {
      old.scrollController?.removeListener(_onScroll);
      widget.scrollController?.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final c = widget.scrollController!;
    final condensed = c.hasClients && c.offset > 24;
    if (condensed != _condensed) setState(() => _condensed = condensed);
  }

  void _openMenu() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierDismissible: true,
        barrierColor: const Color(0x00000000),
        transitionDuration: const Duration(milliseconds: 650),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, _) => _FullScreenMenu(
          animation: animation,
          selectedIndex: widget.selectedIndex,
          isOpen: widget.isOpen,
          onSelect: (i) {
            Navigator.of(context).pop();
            widget.onTabSelected(i);
          },
          onCourtCard: () {
            Navigator.of(context).pop();
            widget.onCourtCardPressed();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final pad = isDesktop ? AppBreakpoints.horizontalPadding(context) : 20.0;

    return AnimatedContainer(
      duration: AppMotion.emphasis,
      curve: AppMotion.defaultCurve,
      decoration: BoxDecoration(
        color: theme.scaffoldBackground,
        border: Border(
          bottom: BorderSide(color: _condensed ? theme.borderLight : theme.scaffoldBackground),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppBreakpoints.desktopMax + pad * 2),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: pad),
              child: isDesktop ? _desktop(theme) : _compact(theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _desktop(ThemeController theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Utility strip folds away on scroll.
        AnimatedSize(
          duration: AppMotion.emphasis,
          curve: AppMotion.defaultCurve,
          alignment: Alignment.topCenter,
          child: _condensed
              ? const SizedBox(width: double.infinity)
              : Column(
                  children: [
                    SizedBox(height: 36, child: _UtilityStrip(isOpen: widget.isOpen)),
                    Container(height: 1, color: theme.borderLight),
                  ],
                ),
        ),
        AnimatedContainer(
          duration: AppMotion.emphasis,
          curve: AppMotion.defaultCurve,
          height: _condensed ? 64 : 80,
          child: Row(
            children: [
              _Wordmark(onTap: () => widget.onTabSelected(0), showSlogan: !_condensed),
              const Spacer(),
              _NavLinks(selectedIndex: widget.selectedIndex, onSelect: widget.onTabSelected),
              const Spacer(),
              ArcoCourtCardButton(onPressed: widget.onCourtCardPressed),
            ],
          ),
        ),
      ],
    );
  }

  Widget _compact(ThemeController theme) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          _Wordmark(onTap: () => widget.onTabSelected(0), showSlogan: false),
          const Spacer(),
          _MenuToggle(onTap: _openMenu),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- wordmark

class _Wordmark extends StatelessWidget {
  final VoidCallback onTap;
  final bool showSlogan;
  const _Wordmark({required this.onTap, required this.showSlogan});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    return Semantics(
      button: true,
      label: 'Arcoffee home',
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  theme.isMidnightCourt ? 'assets/images/logo_orange.png' : 'assets/images/logo_blue.png',
                  height: 22,
                  filterQuality: FilterQuality.medium,
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ARCOFFEE',
                      style: AppTypography.displayXL.copyWith(
                        fontSize: 15,
                        height: 1,
                        letterSpacing: 3.2,
                        fontWeight: FontWeight.w800,
                        color: theme.primaryText,
                      ),
                    ),
                    AnimatedSize(
                      duration: AppMotion.emphasis,
                      curve: AppMotion.defaultCurve,
                      child: showSlogan
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                'COURTSIDE · EST. KAWIT',
                                style: AppTypography.scoreboard.copyWith(
                                  fontSize: 8.5,
                                  height: 1,
                                  letterSpacing: 1.9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accentOrange,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- utility strip

class _UtilityStrip extends StatelessWidget {
  final bool? isOpen;
  const _UtilityStrip({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final meta = AppTypography.scoreboard.copyWith(
      fontSize: 10,
      letterSpacing: 1.8,
      fontWeight: FontWeight.w700,
      color: theme.secondaryText,
    );
    return Row(
      children: [
        if (isOpen != null) ...[
          _StatusDot(open: isOpen!),
          const SizedBox(width: 8),
          Text(
            isOpen! ? 'OPEN NOW · COURT & BAR ACTIVE' : 'CLOSED · OPENS 2PM',
            style: meta.copyWith(color: isOpen! ? AppColors.statusOpen : theme.secondaryText),
          ),
        ],
        const Spacer(),
        Text('THE PICKLEGROUND PH  ·  KAWIT, CAVITE', style: meta),
        const Spacer(),
        _ManilaClock(style: meta),
        const SizedBox(width: 20),
        Container(width: 1, height: 12, color: theme.borderLight),
        const SizedBox(width: 12),
        const _DayNightSwitch(),
      ],
    );
  }
}

/// Kawit local time (UTC+8), so visitors anywhere see the bar's clock.
class _ManilaClock extends StatefulWidget {
  final TextStyle style;
  const _ManilaClock({required this.style});

  @override
  State<_ManilaClock> createState() => _ManilaClockState();
}

class _ManilaClockState extends State<_ManilaClock> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 20), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = DateTime.now().toUtc().add(const Duration(hours: 8));
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    return Text('KAWIT  $h:$m ${t.hour < 12 ? 'AM' : 'PM'}', style: widget.style);
  }
}

class _StatusDot extends StatelessWidget {
  final bool open;
  const _StatusDot({required this.open});

  @override
  Widget build(BuildContext context) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: open ? AppColors.statusOpen : AppColors.statusClosed,
        ),
      );
}

/// "DAY / NIGHT" set as type; the active mode is lit.
class _DayNightSwitch extends StatelessWidget {
  final bool large;
  const _DayNightSwitch({this.large = false});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    Widget option(String label, bool active, CourtThemeMode mode) {
      return Semantics(
        button: true,
        selected: active,
        label: '$label mode',
        excludeSemantics: true,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => theme.setMode(mode),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: large ? 44 : 32, minWidth: 36),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: AppMotion.standard,
                  style: AppTypography.scoreboard.copyWith(
                    fontSize: large ? 12 : 10,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w700,
                    color: active
                        ? AppColors.accentOrange
                        : (large ? AppColors.warmCream.withValues(alpha: 0.45) : theme.tertiaryText),
                  ),
                  child: Text(label),
                ),
              ),
            ),
          ),
        ),
      );
    }

    final night = theme.isMidnightCourt;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        option('DAY', !night, CourtThemeMode.dayCourt),
        Text(
          ' / ',
          style: AppTypography.scoreboard.copyWith(
            fontSize: large ? 12 : 10,
            color: large ? AppColors.warmCream.withValues(alpha: 0.3) : theme.tertiaryText,
          ),
        ),
        option('NIGHT', night, CourtThemeMode.midnightCourt),
      ],
    );
  }
}

// ---------------------------------------------------------------- links

/// Numbered links; one orange underline glides to the active page.
class _NavLinks extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  const _NavLinks({required this.selectedIndex, required this.onSelect});

  @override
  State<_NavLinks> createState() => _NavLinksState();
}

class _NavLinksState extends State<_NavLinks> {
  final _rowKey = GlobalKey();
  final _keys = List.generate(_navLabels.length, (_) => GlobalKey());
  int? _hover;
  Rect? _bar;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void didUpdateWidget(_NavLinks old) {
    super.didUpdateWidget(old);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    if (!mounted) return;
    final target = _hover ?? widget.selectedIndex;
    if (target < 0 || target >= _keys.length) {
      if (_bar != null) setState(() => _bar = null);
      return;
    }
    final row = _rowKey.currentContext?.findRenderObject() as RenderBox?;
    final item = _keys[target].currentContext?.findRenderObject() as RenderBox?;
    if (row == null || item == null || !row.hasSize || !item.hasSize) return;
    final offset = item.localToGlobal(Offset.zero, ancestor: row);
    final rect = offset & item.size;
    if (rect != _bar) setState(() => _bar = rect);
  }

  void _setHover(int? i) {
    _hover = i;
    _measure();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    return MouseRegion(
      onExit: (_) => _setHover(null),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            key: _rowKey,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < _navLabels.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Semantics(
                    button: true,
                    selected: i == widget.selectedIndex,
                    label: _navLabels[i],
                    excludeSemantics: true,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => _setHover(i),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onSelect(i),
                        child: ConstrainedBox(
                          key: _keys[i],
                          constraints: const BoxConstraints(minHeight: 44),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '0${i + 1}',
                                  style: AppTypography.scoreboard.copyWith(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: i == widget.selectedIndex ? AppColors.accentOrange : theme.tertiaryText,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              AnimatedDefaultTextStyle(
                                duration: AppMotion.standard,
                                style: AppTypography.body.copyWith(
                                  fontSize: 15,
                                  letterSpacing: -0.1,
                                  fontWeight: i == widget.selectedIndex ? FontWeight.w700 : FontWeight.w500,
                                  color: i == widget.selectedIndex || i == _hover
                                      ? theme.primaryText
                                      : theme.secondaryText,
                                ),
                                child: Text(_navLabels[i]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (_bar != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutQuart,
              left: _bar!.left,
              width: _bar!.width,
              top: _bar!.bottom - 6,
              height: 1.5,
              child: AnimatedOpacity(
                duration: AppMotion.standard,
                opacity: _hover != null && _hover != widget.selectedIndex ? 0.5 : 1,
                child: const ColoredBox(color: AppColors.accentOrange),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------- court card

/// Court Card: ink capsule with an orange disc whose arrow slides on hover; shows how many drinks are saved.
class ArcoCourtCardButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool expanded;
  const ArcoCourtCardButton({super.key, required this.onPressed, this.expanded = false});

  @override
  State<ArcoCourtCardButton> createState() => _ArcoCourtCardButtonState();
}

class _ArcoCourtCardButtonState extends State<ArcoCourtCardButton> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final night = theme.isMidnightCourt;
    final ink = night ? AppColors.warmCream : AppColors.deepBlue;
    final onInk = night ? AppColors.deepBlue : AppColors.warmCream;
    final card = CourtCardService.instance;

    return AnimatedBuilder(
      animation: card,
      builder: (context, _) {
        final count = card.count;
        return Semantics(
          button: true,
          label: count > 0 ? 'Court Card, $count drinks saved' : 'Court Card',
          excludeSemantics: true,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: GestureDetector(
              onTapDown: (_) => setState(() => _down = true),
              onTapCancel: () => setState(() => _down = false),
              onTapUp: (_) => setState(() => _down = false),
              onTap: widget.onPressed,
              child: AnimatedScale(
                scale: _down ? 0.97 : 1,
                duration: AppMotion.fast,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.only(left: 22, right: 5),
                  decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
                    children: [
                      Text(
                        'Court Card',
                        style: AppTypography.body.copyWith(fontSize: 14, fontWeight: FontWeight.w700, color: onInk),
                      ),
                      if (count > 0) ...[
                        const SizedBox(width: 10),
                        Text(
                          count.toString().padLeft(2, '0'),
                          style: AppTypography.scoreboard.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentOrange,
                          ),
                        ),
                      ],
                      if (widget.expanded) const Spacer() else const SizedBox(width: 14),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: const BoxDecoration(color: AppColors.accentOrange, shape: BoxShape.circle),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedSlide(
                              offset: Offset(_hover ? 2.6 : 0, 0),
                              duration: AppMotion.emphasis,
                              curve: AppMotion.defaultCurve,
                              child: const Text('→', style: TextStyle(fontSize: 16, color: AppColors.pureWhite)),
                            ),
                            AnimatedSlide(
                              offset: Offset(_hover ? 0 : -2.6, 0),
                              duration: AppMotion.emphasis,
                              curve: AppMotion.defaultCurve,
                              child: const Text('→', style: TextStyle(fontSize: 16, color: AppColors.pureWhite)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------- compact menu

/// "Menu" with two lines that morph into a cross.
class _MenuToggle extends StatelessWidget {
  final VoidCallback onTap;
  final bool open;
  final Color? color;
  const _MenuToggle({required this.onTap, this.open = false, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? ThemeScope.of(context).primaryText;
    return Semantics(
      button: true,
      label: open ? 'Close menu' : 'Open menu',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                open ? 'CLOSE' : 'MENU',
                style: AppTypography.scoreboard.copyWith(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w700, color: c),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 22,
                height: 14,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    for (final sign in [-1.0, 1.0])
                      AnimatedRotation(
                        duration: AppMotion.emphasis,
                        curve: AppMotion.defaultCurve,
                        turns: open ? sign * 0.125 : 0,
                        child: AnimatedSlide(
                          duration: AppMotion.emphasis,
                          curve: AppMotion.defaultCurve,
                          offset: Offset(0, open ? 0 : sign * 2.5),
                          child: Container(width: 22, height: 1.6, color: c),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullScreenMenu extends StatelessWidget {
  final Animation<double> animation;
  final int selectedIndex;
  final bool? isOpen;
  final ValueChanged<int> onSelect;
  final VoidCallback onCourtCard;

  const _FullScreenMenu({
    required this.animation,
    required this.selectedIndex,
    required this.isOpen,
    required this.onSelect,
    required this.onCourtCard,
  });

  static const _night = Color(0xFF07111D);
  static const _socials = [
    ('Instagram', 'https://www.instagram.com/arcoffeeph/'),
    ('Facebook', 'https://www.facebook.com/ARCoffee/'),
    ('TikTok', 'https://www.tiktok.com/@arcoffeeph'),
  ];

  Animation<double> _slice(double a, double b) =>
      CurvedAnimation(parent: animation, curve: Interval(a, b, curve: Curves.easeOutCubic));

  Widget _rise(Widget child, double start) {
    final t = _slice(start, (start + 0.5).clamp(0, 1));
    return AnimatedBuilder(
      animation: t,
      child: child,
      builder: (context, child) => Opacity(
        opacity: t.value,
        child: Transform.translate(offset: Offset(0, 36 * (1 - t.value)), child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final fs = (size.width * 0.13).clamp(40.0, 72.0);
    final meta = AppTypography.scoreboard.copyWith(
      fontSize: 10.5,
      letterSpacing: 1.8,
      fontWeight: FontWeight.w700,
      color: AppColors.warmCream.withValues(alpha: 0.55),
    );

    // The night panel wipes down from the top like a court light switching on.
    final wipe = _slice(0, 0.55);
    return AnimatedBuilder(
      animation: wipe,
      builder: (context, child) => ClipRect(
        child: Align(alignment: Alignment.topCenter, heightFactor: wipe.value, child: child),
      ),
      child: ColoredBox(
        color: _night,
        child: SizedBox.expand(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        Image.asset('assets/images/logo_orange.png', height: 22),
                        const SizedBox(width: 12),
                        Text(
                          'ARCOFFEE',
                          style: AppTypography.displayXL.copyWith(
                            fontSize: 15,
                            letterSpacing: 3.2,
                            fontWeight: FontWeight.w800,
                            color: AppColors.warmCream,
                          ),
                        ),
                        const Spacer(),
                        _MenuToggle(open: true, color: AppColors.warmCream, onTap: () => Navigator.of(context).pop()),
                      ],
                    ),
                  ),
                  const Spacer(),
                  for (var i = 0; i < _navLabels.length; i++)
                    _rise(
                      Semantics(
                        button: true,
                        selected: i == selectedIndex,
                        label: _navLabels[i],
                        excludeSemantics: true,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onSelect(i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 36,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: fs * 0.18),
                                    child: Text(
                                      '0${i + 1}',
                                      style: meta.copyWith(
                                        color: i == selectedIndex ? AppColors.accentOrange : null,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  _navLabels[i],
                                  style: AppTypography.displayXL.copyWith(
                                    fontSize: fs,
                                    height: 1.05,
                                    letterSpacing: -fs * 0.04,
                                    fontWeight: i == selectedIndex ? FontWeight.w800 : FontWeight.w200,
                                    color: AppColors.warmCream,
                                  ),
                                ),
                                if (i == selectedIndex)
                                  Padding(
                                    padding: EdgeInsets.only(left: 10, top: fs * 0.22),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(color: AppColors.accentOrange, shape: BoxShape.circle),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      0.2 + i * 0.07,
                    ),
                  const SizedBox(height: 36),
                  _rise(ArcoCourtCardButton(onPressed: onCourtCard, expanded: true), 0.5),
                  const Spacer(),
                  _rise(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 1, color: AppColors.warmCream.withValues(alpha: 0.12)),
                        const SizedBox(height: 18),
                        if (isOpen != null)
                          Row(
                            children: [
                              _StatusDot(open: isOpen!),
                              const SizedBox(width: 8),
                              Text(
                                isOpen! ? 'OPEN NOW · COURT & BAR ACTIVE' : 'CLOSED · OPENS 2PM',
                                style: meta.copyWith(color: isOpen! ? AppColors.statusOpen : null),
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        Text('MON–THU 2PM–10PM  ·  FRI–SUN 24 HOURS', style: meta),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            for (final s in _socials)
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => launchUrl(Uri.parse(s.$2), mode: LaunchMode.externalApplication),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(minHeight: 44),
                                    child: Center(
                                      child: Text(
                                        s.$1,
                                        style: AppTypography.body.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.warmCream,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            const Spacer(),
                            const _DayNightSwitch(large: true),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                    0.6,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
