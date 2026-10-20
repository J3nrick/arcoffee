import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_motion.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/models/menu_item.dart';
import '../../../data/services/court_card_service.dart';
import '../../../shared/components/arco_arch.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_text_link.dart';
import '../../../theme/theme_controller.dart';
import 'drink_sheet.dart';

/// The Court Card: the drinks a visitor has picked, ready to show at the bar.
/// Stands in for online ordering until it exists; nothing here is sent anywhere.
class CourtCardSheet extends StatelessWidget {
  final VoidCallback onBrowseMenu;
  const CourtCardSheet({super.key, required this.onBrowseMenu});

  static Future<void> show(BuildContext context, {required VoidCallback onBrowseMenu}) =>
      showArcoSheet(context, (_) => CourtCardSheet(onBrowseMenu: onBrowseMenu));

  @override
  Widget build(BuildContext context) {
    final card = CourtCardService.instance;
    final theme = ThemeScope.of(context);
    final meta = AppTypography.scoreboard.copyWith(
      fontSize: 10.5,
      letterSpacing: 1.8,
      fontWeight: FontWeight.w700,
      color: theme.tertiaryText,
    );

    return AnimatedBuilder(
      animation: card,
      builder: (context, _) {
        final items = card.items;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'YOUR COURT CARD  ·  ${items.length.toString().padLeft(2, '0')}',
              style: meta.copyWith(color: AppColors.accentOrange),
            ),
            const SizedBox(height: 10),
            Text(
              items.isEmpty ? 'Nothing picked yet.' : 'Picked for the next break.',
              style: AppTypography.displayXL.copyWith(
                fontSize: 30,
                height: 1.08,
                letterSpacing: -0.9,
                fontWeight: FontWeight.w800,
                color: theme.primaryText,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              items.isEmpty
                  ? 'Save drinks from the menu and they land here. When you reach the bar, open your card and show it. No sign-up, nothing to pay online.'
                  : "Not an order. Show this at the bar and we'll pour it fresh. Your picks stay on this device.",
              style: AppTypography.body.copyWith(fontSize: 15, height: 1.6, color: theme.secondaryText),
            ),
            const SizedBox(height: 24),
            if (items.isEmpty) ...[
              Center(
                child: SizedBox(
                  width: 120,
                  height: 150,
                  child: CustomPaint(painter: _ArchOutline(color: theme.borderLight, accent: AppColors.accentOrange)),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ArcoButton(
                  text: 'Browse the menu →',
                  isFullWidth: true,
                  variant: ArcoButtonVariant.primary,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onBrowseMenu();
                  },
                ),
              ),
            ] else ...[
              for (final item in items) _CardRow(item: item),
              Container(height: 1, color: theme.borderLight),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text('ESTIMATED FROM', style: meta),
                  const Spacer(),
                  Text(
                    '₱${card.estimatedFrom.toStringAsFixed(0)}',
                    style: AppTypography.displayXL.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      color: theme.primaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('SMALLEST SIZE OF EACH  ·  PAY AT THE BAR', style: meta.copyWith(fontSize: 9.5)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ArcoButton(
                  text: 'Show at the bar →',
                  isFullWidth: true,
                  variant: ArcoButtonVariant.primary,
                  onPressed: () => _BarView.show(context, items),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: ArcoTextLink(label: 'Clear card', trailing: '', color: theme.secondaryText, onTap: card.clear),
              ),
            ],
            const SizedBox(height: 18),
            Center(child: Text('MON–THU 2PM–10PM  ·  FRI–SUN 24 HOURS', style: meta.copyWith(fontSize: 9.5))),
          ],
        );
      },
    );
  }
}

class _CardRow extends StatelessWidget {
  final MenuItem item;
  const _CardRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: theme.borderLight))),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox.square(
              dimension: 52,
              child: Image.asset(item.imageAsset ?? 'assets/images/espresso_pour_latte.jpg', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.body.copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: theme.primaryText),
                ),
                const SizedBox(height: 3),
                Text(
                  priceLines(item).map((l) => '${l.$1} ₱${l.$2.toStringAsFixed(0)}').join('  /  '),
                  style: AppTypography.scoreboard.copyWith(fontSize: 11, color: theme.secondaryText),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: 'Remove ${item.name}',
            excludeSemantics: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => CourtCardService.instance.remove(item),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                child: Center(
                  child: Text('×', style: TextStyle(fontSize: 22, color: theme.tertiaryText)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty-state mark: an arch outline with an orange arc drawn over its head.
class _ArchOutline extends CustomPainter {
  final Color color;
  final Color accent;
  _ArchOutline({required this.color, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawPath(
      archPath(rect.deflate(8), 4),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = color,
    );
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.width),
      math.pi,
      math.pi * 0.7,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = accent,
    );
  }

  @override
  bool shouldRepaint(_ArchOutline old) => old.color != color || old.accent != accent;
}

/// Full-screen, high-contrast card held up to the barista across the counter.
class _BarView extends StatelessWidget {
  final List<MenuItem> items;
  const _BarView({required this.items});

  static void show(BuildContext context, List<MenuItem> items) {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => _BarView(items: items),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.04, end: 1).animate(CurvedAnimation(parent: anim, curve: AppMotion.defaultCurve)),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final fs = (size.width * 0.09).clamp(30.0, 64.0) * (items.length > 4 ? 0.75 : 1);
    final meta = AppTypography.scoreboard.copyWith(
      fontSize: 11,
      letterSpacing: 2,
      fontWeight: FontWeight.w700,
      color: AppColors.warmCream.withValues(alpha: 0.55),
      decoration: TextDecoration.none,
    );

    return Semantics(
      label: 'Court Card for the barista. Tap to close.',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: ColoredBox(
          color: const Color(0xFF07111D),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/logo_orange.png', height: 22),
                          const SizedBox(width: 12),
                          Text('COURT CARD', style: meta.copyWith(color: AppColors.accentOrange)),
                          const Spacer(),
                          Text('${items.length.toString().padLeft(2, '0')} DRINKS', style: meta),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(height: 1, color: AppColors.warmCream.withValues(alpha: 0.14)),
                      // Centred when it fits; scrolls if the card is long.
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                              for (var i = 0; i < items.length; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 44,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: fs * 0.2),
                                          child: Text((i + 1).toString().padLeft(2, '0'), style: meta.copyWith(color: AppColors.accentOrange)),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              items[i].name,
                                              style: AppTypography.displayXL.copyWith(
                                                fontSize: fs,
                                                height: 1.05,
                                                letterSpacing: -fs * 0.03,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.warmCream,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              priceLines(items[i]).map((l) => '${l.$1.toUpperCase()} ₱${l.$2.toStringAsFixed(0)}').join('   /   '),
                                              style: meta,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(height: 1, color: AppColors.warmCream.withValues(alpha: 0.14)),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: Text('SHOW THIS TO THE BARISTA', style: meta.copyWith(color: AppColors.warmCream))),
                          Text('TAP TO CLOSE', style: meta),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
