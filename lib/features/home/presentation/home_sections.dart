import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_motion.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/models/menu_item.dart';
import '../../../shared/components/arco_arch.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_footer.dart';
import '../../../shared/components/arco_in_view.dart';
import '../../../theme/theme_controller.dart';
import '../../court_card/presentation/drink_sheet.dart';

/// Section heading set in two weights: a heavy statement, then a thin echo.
class _SplitHeading extends StatelessWidget {
  final String bold;
  final String thin;
  final String? lede;

  const _SplitHeading({required this.bold, required this.thin, this.lede});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final fs = isDesktop ? 54.0 : 34.0;
    return ArcoInView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: '$bold\n',
                style: const TextStyle(fontWeight: FontWeight.w800, fontVariations: [FontVariation('wght', 800)]),
              ),
              TextSpan(
                text: thin,
                style: const TextStyle(fontWeight: FontWeight.w200, fontVariations: [FontVariation('wght', 200)]),
              ),
            ]),
            textAlign: TextAlign.center,
            style: AppTypography.displayXL.copyWith(
              fontSize: fs,
              height: 1.04,
              letterSpacing: -fs * 0.035,
              color: theme.primaryText,
            ),
          ),
          if (lede != null) ...[
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                lede!,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(fontSize: 16, height: 1.6, color: theme.secondaryText),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Widget _section(BuildContext context, Widget child, {double? top, double? bottom}) {
  final isDesktop = AppBreakpoints.isDesktop(context);
  return Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(
      AppBreakpoints.horizontalPadding(context),
      top ?? (isDesktop ? 120 : 72),
      AppBreakpoints.horizontalPadding(context),
      bottom ?? (isDesktop ? 120 : 72),
    ),
    child: Center(
      child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax), child: child),
    ),
  );
}

// ============================================================== numbers

/// Three true figures in court circles; the orange arcs draw and the numbers count up on arrival.
class HomeNumbersSection extends StatelessWidget {
  final int drinkCount;

  const HomeNumbersSection({super.key, required this.drinkCount});

  @override
  Widget build(BuildContext context) {
    final isMobile = AppBreakpoints.isMobile(context);
    final stats = [
      (drinkCount, '', 'CRAFT DRINKS\nON THE BOARD'),
      (24, 'H', 'NON-STOP\nFRIDAY TO SUNDAY'),
      (4, '', 'DRINK SERIES\nCOFFEE TO MATCHA'),
    ];
    final d = isMobile ? 150.0 : 210.0;

    return _section(
      context,
      Column(
        children: [
          const _SplitHeading(
            bold: 'Brewed between rallies,',
            thin: 'one sip at a time.',
            lede: 'From the first serve at 2PM to the last rally of a 24-hour weekend, the bar keeps pace with the courts.',
          ),
          SizedBox(height: isMobile ? 48 : 80),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: isMobile ? 20 : 72,
            runSpacing: 32,
            children: [
              for (var i = 0; i < stats.length; i++)
                ArcoInView(
                  delay: Duration(milliseconds: 160 * i),
                  duration: const Duration(milliseconds: 1600),
                  builder: (context, t) => _StatCircle(
                    diameter: d,
                    t: t,
                    value: stats[i].$1,
                    suffix: stats[i].$2,
                    label: stats[i].$3,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCircle extends StatelessWidget {
  final double diameter;
  final double t;
  final int value;
  final String suffix;
  final String label;

  const _StatCircle({required this.diameter, required this.t, required this.value, required this.suffix, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final shown = (value * t).round().toString().padLeft(2, '0');
    return SizedBox.square(
      dimension: diameter + 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Container(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.cardBackground,
                border: Border.all(color: theme.borderLight),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: ArcoArcStroke(progress: t, startAngle: math.pi * 0.8, sweep: math.pi * 0.9, strokeWidth: 3),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$shown$suffix',
                style: AppTypography.displayXL.copyWith(
                  fontSize: diameter * 0.26,
                  height: 1,
                  letterSpacing: -diameter * 0.008,
                  fontWeight: FontWeight.w800,
                  color: theme.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.scoreboard.copyWith(
                  fontSize: diameter < 180 ? 8.5 : 10,
                  height: 1.5,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                  color: theme.tertiaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================== story

/// Two alternating chapters: a circle photograph framed by a drawn orange arc,
/// beside a text panel held by a drawn orange bracket.
class HomeStorySection extends StatelessWidget {
  final VoidCallback onOpenCourtCard;

  const HomeStorySection({super.key, required this.onOpenCourtCard});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(context);
    return _section(
      context,
      Column(
        children: [
          const _SplitHeading(bold: 'Built for the court.', thin: 'Kept by the community.'),
          SizedBox(height: isDesktop ? 96 : 48),
          const _StoryRow(
            asset: 'assets/images/espresso_pour_latte.jpg',
            kicker: '01  ·  THE CRAFT',
            title: 'Pulled to order, between games.',
            body: 'Every shot is tamped and pulled on a commercial grouphead the moment you order, so it reaches your bench at its best. No batch brew, no shortcuts.',
          ),
          SizedBox(height: isDesktop ? 96 : 56),
          _StoryRow(
            asset: 'assets/images/soda_trio_court.jpg',
            kicker: '02  ·  THE COURT CARD',
            title: 'Pick it before you play.',
            body: "Ordering from your court is coming soon. Until then, save your drinks to a Court Card and show it at the bar between games. We'll pour it fresh.",
            reversed: true,
            action: ArcoButton(text: 'Open your Court Card →', onPressed: onOpenCourtCard, variant: ArcoButtonVariant.primary),
          ),
        ],
      ),
      top: 40,
    );
  }
}

class _StoryRow extends StatelessWidget {
  final String asset;
  final String kicker;
  final String title;
  final String body;
  final bool reversed;
  final Widget? action;

  const _StoryRow({
    required this.asset,
    required this.kicker,
    required this.title,
    required this.body,
    this.reversed = false,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final d = isDesktop ? 380.0 : 260.0;

    final photo = ArcoInView(
      duration: const Duration(milliseconds: 1400),
      builder: (context, t) => SizedBox.square(
        dimension: d + 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: ArcoArcStroke(
                  progress: t,
                  startAngle: reversed ? -math.pi * 0.1 : math.pi * 0.9,
                  sweep: math.pi * 1.25,
                  strokeWidth: 2,
                ),
              ),
            ),
            Opacity(
              opacity: t,
              child: Transform.scale(
                scale: 0.94 + 0.06 * t,
                child: ClipOval(child: SizedBox.square(dimension: d, child: Image.asset(asset, fit: BoxFit.cover))),
              ),
            ),
          ],
        ),
      ),
    );

    final text = ArcoInView(
      delay: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 1400),
      builder: (context, t) => CustomPaint(
        painter: _BracketPainter(progress: t, mirrored: reversed, color: AppColors.accentOrange),
        child: Padding(
          padding: EdgeInsets.fromLTRB(reversed ? 36 : 28, 36, reversed ? 28 : 36, 36),
          child: Opacity(
            opacity: t,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  kicker,
                  style: AppTypography.scoreboard.copyWith(
                    fontSize: 11,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentOrange,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: AppTypography.headingXL.copyWith(
                    fontSize: isDesktop ? 34 : 26,
                    height: 1.1,
                    letterSpacing: -0.8,
                    fontWeight: FontWeight.w800,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 14),
                Text(body, style: AppTypography.body.copyWith(fontSize: 16, height: 1.65, color: theme.secondaryText)),
                if (action != null) ...[const SizedBox(height: 28), action!],
              ],
            ),
          ),
        ),
      ),
    );

    if (!isDesktop) {
      return Column(children: [photo, const SizedBox(height: 24), text]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: reversed
          ? [Expanded(child: text), const SizedBox(width: 72), photo]
          : [photo, const SizedBox(width: 72), Expanded(child: text)],
    );
  }
}

/// Open bracket around a text panel: top edge, rounded corner, side, rounded corner, part of the bottom.
class _BracketPainter extends CustomPainter {
  final double progress;
  final bool mirrored;
  final Color color;
  _BracketPainter({required this.progress, required this.mirrored, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    const r = 28.0;
    final w = size.width, h = size.height;
    var path = Path()
      ..moveTo(w * 0.35, 1)
      ..lineTo(w - r, 1)
      ..arcToPoint(Offset(w - 1, r), radius: const Radius.circular(r))
      ..lineTo(w - 1, h - r)
      ..arcToPoint(Offset(w - r, h - 1), radius: const Radius.circular(r))
      ..lineTo(w * 0.55, h - 1);
    if (mirrored) {
      path = path.transform((Matrix4.diagonal3Values(-1, 1, 1)..setTranslationRaw(w, 0, 0)).storage);
    }
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_BracketPainter old) => old.progress != progress || old.mirrored != mirrored || old.color != color;
}

// ============================================================== shop

/// The line-up: arch-framed cards that open the drink sheet; Save puts a drink on the Court Card.
class HomeShopSection extends StatelessWidget {
  final List<MenuItem> items;
  final VoidCallback onExploreFullMenu;

  const HomeShopSection({super.key, required this.items, required this.onExploreFullMenu});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final isMobile = AppBreakpoints.isMobile(context);
    final picks = items.take(4).toList();

    final cards = <Widget>[
      for (var i = 0; i < picks.length; i++)
        ArcoInView(delay: Duration(milliseconds: 100 * i), child: _ShopCard(item: picks[i])),
    ];

    return _section(
      context,
      Column(
        children: [
          const _SplitHeading(
            bold: 'Find your court-side drink.',
            thin: 'Shop the line-up.',
            lede: 'The drinks regulars come back for. Save a few to your Court Card, then show it at the bar between games.',
          ),
          SizedBox(height: isMobile ? 40 : 72),
          if (isMobile)
            SizedBox(
              height: 470,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                physics: const BouncingScrollPhysics(),
                itemCount: cards.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) => SizedBox(width: 270, child: cards[i]),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, c) {
                final cols = isDesktop ? 4 : 2;
                const gap = 24.0;
                final w = (c.maxWidth - gap * (cols - 1)) / cols;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [for (final card in cards) SizedBox(width: w, child: card)],
                );
              },
            ),
          const SizedBox(height: 48),
          ArcoButton(
            text: 'See the full menu →',
            onPressed: onExploreFullMenu,
            variant: ArcoButtonVariant.secondary,
          ),
          const SizedBox(height: 4),
          Text(
            'PRICES IN PHP  ·  PAY AT THE BAR',
            style: AppTypography.scoreboard.copyWith(fontSize: 10, letterSpacing: 1.6, color: theme.tertiaryText),
          ),
        ],
      ),
    );
  }
}

class _ShopCard extends StatefulWidget {
  final MenuItem item;
  const _ShopCard({required this.item});

  @override
  State<_ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<_ShopCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final item = widget.item;
    return Semantics(
      button: true,
      label: '${item.name}, ${item.displayPrice}. View details.',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () => DrinkSheet.show(context, item),
          child: AnimatedContainer(
            duration: AppMotion.emphasis,
            curve: AppMotion.defaultCurve,
            transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.cardBackground,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _hover ? AppColors.accentOrange.withValues(alpha: 0.6) : theme.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 0.86,
                  child: ArcoArch(
                    bottomRadius: 14,
                    child: AnimatedScale(
                      scale: _hover ? 1.06 : 1,
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      child: Image.asset(item.imageAsset ?? 'assets/images/espresso_pour_latte.jpg', fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.category.displayName.toUpperCase(),
                        style: AppTypography.scoreboard.copyWith(
                          fontSize: 10,
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentOrange,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headingXL.copyWith(
                          fontSize: 21,
                          letterSpacing: -0.4,
                          fontWeight: FontWeight.w800,
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(height: 1.5, color: theme.secondaryText),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.displayPrice,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.scoreboard.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: theme.primaryText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CourtCardSaveButton(item: item, compact: true),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================== join

/// Closing statement: "Join the Club" set enormous and thin, an arch portrait
/// of a regular breaking the line, and the signup beside it.
class HomeJoinSection extends StatelessWidget {
  const HomeJoinSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final fs = (width * (isDesktop ? 0.135 : 0.17)).clamp(56.0, 210.0);
    final archW = isDesktop ? 300.0 : (width * 0.5).clamp(180.0, 260.0);

    final words = ArcoInView(
      child: Text(
        'Join the Club',
        maxLines: 1,
        softWrap: false,
        textAlign: TextAlign.center,
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

    final arch = ArcoInView(
      duration: const Duration(milliseconds: 1400),
      builder: (context, t) => SizedBox(
        width: archW + 36,
        height: archW * 1.3 + 18,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              width: archW + 36,
              height: archW + 36,
              child: CustomPaint(painter: ArcoArcStroke(progress: t, startAngle: math.pi, sweep: math.pi, strokeWidth: 2)),
            ),
            Positioned(
              left: 18,
              top: 18,
              width: archW,
              height: archW * 1.3,
              child: Opacity(
                opacity: t,
                child: ArcoArch(child: Image.asset('assets/images/community_milo_jersey.jpg', fit: BoxFit.cover)),
              ),
            ),
          ],
        ),
      ),
    );

    final pitch = ArcoInView(
      delay: const Duration(milliseconds: 150),
      child: Column(
        crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            'MEMBERS HEAR IT FIRST',
            style: AppTypography.scoreboard.copyWith(
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
              color: AppColors.accentOrange,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Stay caffeinated.\nStay courtside.',
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            style: AppTypography.headingXL.copyWith(
              fontSize: isDesktop ? 40 : 30,
              height: 1.08,
              letterSpacing: -1,
              fontWeight: FontWeight.w800,
              color: theme.primaryText,
            ),
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Text(
              'Late-night session schedules, court drops and off-menu creations, straight to your inbox.',
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              style: AppTypography.body.copyWith(fontSize: 16, height: 1.6, color: theme.secondaryText),
            ),
          ),
          const SizedBox(height: 24),
          const ArcoJoinForm(showHeading: false),
        ],
      ),
    );

    return _section(
      context,
      isDesktop
          ? Column(
              children: [
                FittedBox(fit: BoxFit.scaleDown, child: words),
                Transform.translate(
                  offset: Offset(0, -fs * 0.42),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Spacer(flex: 1),
                      arch,
                      const SizedBox(width: 72),
                      Expanded(flex: 3, child: Padding(padding: EdgeInsets.only(bottom: fs * 0.1), child: pitch)),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                FittedBox(fit: BoxFit.scaleDown, child: words),
                const SizedBox(height: 8),
                arch,
                const SizedBox(height: 32),
                pitch,
              ],
            ),
      bottom: isDesktop ? 40 : 56,
    );
  }
}
