import 'package:flutter/cupertino.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_motion.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/models/menu_item.dart';
import '../../../data/services/court_card_service.dart';
import '../../../shared/components/arco_arch.dart';
import '../../../theme/theme_controller.dart';

/// Bottom sheet frame shared by the drink sheet and the Court Card.
Future<void> showArcoSheet(BuildContext context, WidgetBuilder builder) {
  return showCupertinoModalPopup<void>(
    context: context,
    barrierColor: const Color(0x8007111D),
    builder: (ctx) {
      final theme = ThemeScope.of(ctx);
      return Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 620,
            maxHeight: MediaQuery.sizeOf(ctx).height * 0.92,
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.scaffoldBackground,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                      child: DefaultTextStyle(
                        style: AppTypography.body.copyWith(decoration: TextDecoration.none),
                        child: builder(ctx),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

/// Price lines exactly as listed on the menu board.
List<(String, double)> priceLines(MenuItem i) {
  if (i.hotPrice != null && i.icedPrice != null) return [('Hot', i.hotPrice!), ('Iced', i.icedPrice!)];
  if (i.price16oz != null && i.price22oz != null) return [('16 oz', i.price16oz!), ('22 oz', i.price22oz!)];
  return [(i.size, i.price)];
}

/// One drink, honestly: photo, story, the board's prices, add-ons to ask for,
/// and a way to keep it on your Court Card for when you reach the bar.
class DrinkSheet extends StatelessWidget {
  final MenuItem item;
  const DrinkSheet({super.key, required this.item});

  static Future<void> show(BuildContext context, MenuItem item) =>
      showArcoSheet(context, (_) => DrinkSheet(item: item));

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final meta = AppTypography.scoreboard.copyWith(
      fontSize: 10.5,
      letterSpacing: 1.8,
      fontWeight: FontWeight.w700,
      color: theme.tertiaryText,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 132,
              height: 176,
              child: ArcoArch(
                child: Image.asset(item.imageAsset ?? 'assets/images/espresso_pour_latte.jpg', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.category.displayName.toUpperCase(), style: meta.copyWith(color: AppColors.accentOrange)),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    style: AppTypography.displayXL.copyWith(
                      fontSize: 30,
                      height: 1.05,
                      letterSpacing: -0.9,
                      fontWeight: FontWeight.w800,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(item.caffeineNote.toUpperCase(), style: meta),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(item.description, style: AppTypography.body.copyWith(fontSize: 15, height: 1.6, color: theme.secondaryText)),
        const SizedBox(height: 26),
        Text('ON THE BOARD', style: meta),
        const SizedBox(height: 6),
        for (final line in priceLines(item))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(line.$1, style: AppTypography.body.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: theme.primaryText)),
                Expanded(
                  child: Container(margin: const EdgeInsets.fromLTRB(12, 0, 12, 5), height: 1, color: theme.borderLight),
                ),
                Text(
                  '₱${line.$2.toStringAsFixed(0)}',
                  style: AppTypography.scoreboard.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: theme.primaryText),
                ),
              ],
            ),
          ),
        const SizedBox(height: 18),
        Text('ASK AT THE BAR', style: meta),
        const SizedBox(height: 8),
        Text(
          barAddOns.map((a) => '${a.$1} ${a.$2}').join('   ·   '),
          style: AppTypography.bodySmall.copyWith(height: 1.7, color: theme.secondaryText),
        ),
        const SizedBox(height: 28),
        CourtCardSaveButton(item: item, expanded: true),
        const SizedBox(height: 14),
        Text(
          "We don't take online orders yet. Save your picks and show your Court Card at the bar. We'll pour it fresh.",
          style: AppTypography.bodySmall.copyWith(height: 1.55, color: theme.tertiaryText),
        ),
      ],
    );
  }
}

/// Save / Saved toggle for a drink's place on the Court Card.
class CourtCardSaveButton extends StatefulWidget {
  final MenuItem item;
  final bool expanded;
  final bool compact;

  const CourtCardSaveButton({super.key, required this.item, this.expanded = false, this.compact = false});

  @override
  State<CourtCardSaveButton> createState() => _CourtCardSaveButtonState();
}

class _CourtCardSaveButtonState extends State<CourtCardSaveButton> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final card = CourtCardService.instance;
    final theme = ThemeScope.of(context);
    return AnimatedBuilder(
      animation: card,
      builder: (context, _) {
        final saved = card.contains(widget.item);
        final label = widget.compact
            ? (saved ? 'Saved' : 'Save')
            : (saved ? 'On your Court Card' : 'Save to Court Card');
        final bg = saved
            ? theme.scaffoldBackground
            : (_hover ? AppColors.accentOrange.withValues(alpha: 0.9) : AppColors.accentOrange);
        final fg = saved ? AppColors.accentOrange : AppColors.pureWhite;

        final button = AnimatedContainer(
          duration: AppMotion.standard,
          curve: AppMotion.defaultCurve,
          height: widget.compact ? 40 : 48,
          width: widget.expanded ? double.infinity : null,
          padding: EdgeInsets.symmetric(horizontal: widget.compact ? 16 : 22),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(widget.compact ? 10 : 24),
            border: Border.all(color: AppColors.accentOrange, width: 1.2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: AppMotion.standard,
                transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                child: Text(
                  saved ? '✓' : '+',
                  key: ValueKey(saved),
                  style: AppTypography.body.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: fg),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTypography.body.copyWith(
                  fontSize: widget.compact ? 13 : 14,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ),
        );

        return Semantics(
          button: true,
          toggled: saved,
          label: saved ? '${widget.item.name} is on your Court Card. Tap to remove.' : 'Save ${widget.item.name} to your Court Card',
          excludeSemantics: true,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _hover = true),
            onExit: (_) => setState(() => _hover = false),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (_) => setState(() => _down = true),
              onTapCancel: () => setState(() => _down = false),
              onTapUp: (_) => setState(() => _down = false),
              onTap: () => card.toggle(widget.item),
              child: AnimatedScale(
                scale: _down ? 0.96 : 1,
                duration: AppMotion.fast,
                // Hug the label unless asked to fill; a centred Container would otherwise stretch.
                child: widget.expanded ? button : IntrinsicWidth(child: button),
              ),
            ),
          ),
        );
      },
    );
  }
}
