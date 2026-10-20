import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_motion.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/models/store_info.dart';
import '../../../data/repositories/store_repository.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_in_view.dart';
import '../../../shared/components/arco_lightbox.dart';
import '../../../shared/components/arco_page_cover.dart';
import '../../../shared/components/arco_text_link.dart';
import '../../../theme/theme_controller.dart';

/// Location & Hours: scoreboard-style schedule, live status, venue photograph and directions.
class LocationView extends StatefulWidget {
  final StoreRepository repository;

  /// True when shown as its own page (adds the cover).
  final bool standalone;

  const LocationView({super.key, required this.repository, this.standalone = false});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  StoreInfo? _storeInfo;
  bool _isOpenNow = true;
  bool _isLoading = true;
  bool _copiedAddress = false;

  static const String _address = "The Pickleground PH, Centennial Road, Kawit, Cavite";
  static const String _courtLocationAsset = 'assets/images/court_arena_drink.jpg';

  Future<void> _openDirections() async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=14.4445,120.9038');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _copyAddress() async {
    await Clipboard.setData(const ClipboardData(text: _address));
    if (!mounted) return;
    setState(() => _copiedAddress = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _copiedAddress = false);
    });
  }

  void _openLocationLightbox() => showArcoLightbox(
        context,
        asset: _courtLocationAsset,
        title: 'THE PICKLEGROUND PH  ·  KAWIT ARENA',
        story: 'Arcoffee courtside specialty bar operating alongside tournament-standard pickleball courts in Kawit, Cavite.',
      );

  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }

  Future<void> _loadStoreData() async {
    final info = await widget.repository.getStoreInfo();
    final isOpen = await widget.repository.isStoreOpenCurrently();
    if (!mounted) return;
    setState(() {
      _storeInfo = info;
      _isOpenNow = isOpen;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pad = AppBreakpoints.horizontalPadding(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final theme = ThemeScope.of(context);

    final body = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: isDesktop ? 112 : 56),
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
                  ArcoInView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AR / 004   ·   FIND US AT THE COURT',
                          style: AppTypography.scoreboard.copyWith(
                            fontSize: 11,
                            letterSpacing: 1.8,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentOrange,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(height: 1, color: theme.borderLight),
                      ],
                    ),
                  ),
                  SizedBox(height: isDesktop ? 56 : 36),
                  if (isDesktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: ArcoInView(child: _buildStory(_storeInfo!, theme))),
                        const SizedBox(width: 80),
                        Expanded(
                          flex: 5,
                          child: ArcoInView(
                            delay: const Duration(milliseconds: 140),
                            child: _buildPhoto(theme, height: 560),
                          ),
                        ),
                      ],
                    )
                  else ...[
                    ArcoInView(child: _buildStory(_storeInfo!, theme)),
                    const SizedBox(height: 48),
                    ArcoInView(child: _buildPhoto(theme, height: 420)),
                  ],
                ],
              ),
      ),
    );

    if (!widget.standalone) return body;
    return Column(
      children: [
        ArcoPageCover(
          index: 'AR / 004',
          kicker: 'KAWIT, CAVITE  ·  14.4445° N, 120.9038° E',
          title: 'FIND US\nCOURTSIDE.',
          lede: 'Inside The Pickleground PH on the Kawit–Noveleta line, minutes off Cavitex. The bar runs all night on weekends.',
          imageAsset: 'assets/images/soda_trio_court.jpg',
          caption: 'PLATE — SODA FLIGHT ON THE BASELINE',
          actions: [
            ArcoButton(text: 'Get Directions →', onPressed: _openDirections, variant: ArcoButtonVariant.primary),
            ArcoTextLink(label: _copiedAddress ? 'Address copied' : 'Copy address', trailing: '', onTap: _copyAddress),
          ],
        ),
        body,
      ],
    );
  }

  Widget _buildStory(StoreInfo store, ThemeController theme) {
    final isDesktop = AppBreakpoints.isDesktop(context);
    final isMobile = AppBreakpoints.isMobile(context);
    final big = (isMobile ? 34.0 : (isDesktop ? 56.0 : 46.0));

    Widget scoreRow(String days, String hours, {bool highlight = false}) {
      final color = highlight ? AppColors.accentOrange : theme.primaryText;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 1, color: theme.borderLight),
          const SizedBox(height: 16),
          Text(
            days,
            style: AppTypography.scoreboard.copyWith(
              fontSize: 11,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w700,
              color: theme.tertiaryText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hours,
            style: AppTypography.displayXL.copyWith(
              fontSize: big,
              height: 1.0,
              letterSpacing: -big * 0.035,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          store.venue,
          style: AppTypography.headingXL.copyWith(
            fontSize: isMobile ? 26 : 32,
            letterSpacing: -0.8,
            fontWeight: FontWeight.w800,
            color: theme.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${store.address}, ${store.province}",
          style: AppTypography.bodyLarge.copyWith(fontSize: 16, color: theme.secondaryText),
        ),
        const SizedBox(height: 4),
        Text(
          "Beside the Kawit / Noveleta corridors with direct Cavitex access.",
          style: AppTypography.body.copyWith(fontSize: 14, color: theme.tertiaryText),
        ),
        const SizedBox(height: 40),
        scoreRow('MONDAY — THURSDAY', '2PM — 10PM'),
        scoreRow('FRIDAY — SUNDAY', '24 HOURS.', highlight: true),
        Container(height: 1, color: theme.borderLight),
        const SizedBox(height: 20),
        Row(
          children: [
            _LiveDot(color: _isOpenNow ? AppColors.statusOpen : AppColors.statusClosed, pulse: _isOpenNow),
            const SizedBox(width: 10),
            Text(
              _isOpenNow ? "OPEN NOW  ·  COURT & BAR ACTIVE" : "CLOSED NOW  ·  SEE YOU AT 2PM",
              style: AppTypography.scoreboard.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: _isOpenNow ? AppColors.statusOpen : AppColors.statusClosed,
              ),
            ),
          ],
        ),
        if (!widget.standalone) ...[
          const SizedBox(height: 40),
          Wrap(
            spacing: 28,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ArcoButton(text: 'Get Directions →', onPressed: _openDirections, variant: ArcoButtonVariant.primary),
              ArcoTextLink(
                label: _copiedAddress ? 'Address copied' : 'Copy address',
                trailing: '',
                color: theme.primaryText,
                onTap: _copyAddress,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPhoto(ThemeController theme, {required double height}) {
    final meta = AppTypography.scoreboard.copyWith(fontSize: 10.5, letterSpacing: 1.6, fontWeight: FontWeight.w700);
    return Semantics(
      button: true,
      label: 'Open venue photograph',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _openLocationLightbox,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: height,
                  width: double.infinity,
                  child: Image.asset(_courtLocationAsset, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text('14.4445° N, 120.9038° E', style: meta.copyWith(color: AppColors.accentOrange)),
                  const Spacer(),
                  Text('KAWIT ARENA', style: meta.copyWith(color: theme.tertiaryText)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Status dot with a slow breathing ring while the bar is open.
class _LiveDot extends StatefulWidget {
  final Color color;
  final bool pulse;
  const _LiveDot({required this.color, required this.pulse});

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.pulse && !AppMotion.isReducedMotion(context)) {
      _c.repeat();
    } else {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => Stack(
          alignment: Alignment.center,
          children: [
            if (_c.isAnimating)
              Container(
                width: 8 + 10 * _c.value,
                height: 8 + 10 * _c.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.35 * (1 - _c.value)),
                ),
              ),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }
}
