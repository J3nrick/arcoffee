import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/repositories/gallery_repository.dart';
import '../../../shared/components/arco_in_view.dart';
import '../../../shared/components/arco_lightbox.dart';
import '../../../shared/components/arco_page_cover.dart';
import '../../../theme/theme_controller.dart';

/// "The Arcoffee Wall" Editorial Collage Section.
/// Showcases all authentic courtside & lifestyle photographs with interactive full-screen lightbox.
class GalleryView extends StatefulWidget {
  final GalleryRepository repository;

  /// True when shown as its own page (adds the cover, drops the section header).
  final bool standalone;

  const GalleryView({super.key, required this.repository, this.standalone = false});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  bool _isLoading = true;

  // Complete curated photographic lifestyle assets representing court, coffee, community
  static const List<Map<String, String>> _editorialPhotos = [
    {
      'asset': 'assets/images/court_arena_drink.jpg',
      'title': 'COURT ACTION',
      'caption': 'THE PICKLEGROUND ARENA',
      'story': 'Full court lighting during our 24-hour weekend session at The Pickleground, Kawit, Cavite.',
    },
    {
      'asset': 'assets/images/community_milo_jersey.jpg',
      'title': 'COMMUNITY',
      'caption': 'GOOD COFFEE. GOOD PEOPLE.',
      'story': 'Post-match debrief with cold brews, Milo Overload, and local players courtside.',
    },
    {
      'asset': 'assets/images/lychee_soda_chat_paddle.jpg',
      'title': 'COURTSIDE BANTER',
      'caption': 'JOOLA PADDLE & LYCHEE SODA',
      'story': 'Fast rallies, paddle drops, and sparkling refreshers between games.',
    },
    {
      'asset': 'assets/images/portafilter_tamp.jpg',
      'title': 'BARISTA CRAFT',
      'caption': 'PRECISION DOUBLE EXTRACTION',
      'story': 'Precision-tamped espresso shots pulled on our commercial chrome grouphead.',
    },
    {
      'asset': 'assets/images/green_apple_court_line.jpg',
      'title': 'BASELINE REFRESH',
      'caption': 'GREEN APPLE SPARKLER',
      'story': 'Zero-heat sparkling sodas resting right on the pickleball court boundary line.',
    },
    {
      'asset': 'assets/images/latte_pull_portrait.png',
      'title': 'SIGNATURE POUR',
      'caption': 'ICED LATTE CRAFT',
      'story': 'Velvety espresso pouring straight over rich chilled milk on the bar counter.',
    },
    {
      'asset': 'assets/images/soda_trio_court.jpg',
      'title': 'SODA FLIGHT',
      'caption': 'COURT LINEUP TRIO',
      'story': 'Effervescent fruit sodas lined up on the court baseline during tournament play.',
    },
    {
      'asset': 'assets/images/mango_americano_espresso.jpg',
      'title': 'ESPRESSO MACHINE',
      'caption': 'COMMERCIAL GROUPHEAD PULL',
      'story': 'Fresh double-shot extraction for the layered Mango Americano specialty.',
    },
    {
      'asset': 'assets/images/green_apple_sky.jpg',
      'title': 'CAVITE SKYLINE',
      'caption': 'GOLDEN HOUR SPARKLER',
      'story': 'Ice-cold green apple carbonation resting under the afternoon Cavite sky.',
    },
  ];

  // Asymmetric collage rhythm per row: (flex, photo height, drop from row top).
  static const List<List<(int, double, double)>> _collageRows = [
    [(4, 420, 0), (3, 340, 72), (4, 380, 24)],
    [(3, 360, 32), (4, 440, 0), (4, 360, 56)],
    [(4, 380, 0), (4, 420, 40), (3, 340, 12)],
  ];

  @override
  void initState() {
    super.initState();
    _loadGalleryData();
  }

  Future<void> _loadGalleryData() async {
    await widget.repository.getGalleryItems();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void _openPhoto(int i) {
    final photo = _editorialPhotos[i];
    showArcoLightbox(
      context,
      asset: photo['asset']!,
      title: '${(i + 1).toString().padLeft(2, '0')}  ·  ${photo['title']}  ·  ${photo['caption']}',
      story: photo['story']!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final pad = AppBreakpoints.horizontalPadding(context);

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
                  if (!widget.standalone) ...[
                    _buildSectionHeader(theme, isDesktop),
                    SizedBox(height: isDesktop ? 80 : 40),
                  ],
                  if (isDesktop) _buildDesktopCollage(theme) else _buildMobileCollage(theme),
                ],
              ),
      ),
    );

    if (!widget.standalone) return body;
    return Column(
      children: [
        const ArcoPageCover(
          index: 'AR / 003',
          kicker: 'THE ARCOFFEE WALL  ·  COMMUNITY  ·  SHOT ON COURT',
          title: 'GOOD\nPEOPLE.',
          lede: 'Good coffee, good people, good games. Nine plates from the bench, the bar and the baseline at The Pickleground PH.',
          imageAsset: 'assets/images/community_milo_jersey.jpg',
          caption: 'PLATE — POST-MATCH DEBRIEF, COURT 2',
        ),
        body,
      ],
    );
  }

  Widget _buildSectionHeader(ThemeController theme, bool isDesktop) {
    final title = Text(
      'Good coffee.\nGood people.\nGood games.',
      style: AppTypography.displayXL.copyWith(
        fontSize: isDesktop ? 76 : 44,
        height: 0.94,
        letterSpacing: isDesktop ? -2.6 : -1.4,
        fontWeight: FontWeight.w900,
        color: theme.primaryText,
      ),
    );
    final aside = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Shot on court, at the bar and on the bench. Tap any plate to see it full size.',
          style: AppTypography.body.copyWith(fontSize: 15, height: 1.55, color: theme.secondaryText),
        ),
        const SizedBox(height: 14),
        Text(
          '${_editorialPhotos.length.toString().padLeft(2, '0')} PLATES  ·  KAWIT, CAVITE',
          style: AppTypography.scoreboard.copyWith(
            fontSize: 11,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w700,
            color: AppColors.accentOrange,
          ),
        ),
      ],
    );
    return ArcoInView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AR / 003   ·   THE ARCOFFEE WALL',
            style: AppTypography.scoreboard.copyWith(
              fontSize: 11,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w700,
              color: AppColors.accentOrange,
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: theme.borderLight),
          const SizedBox(height: 32),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(flex: 7, child: title),
                const SizedBox(width: 48),
                Expanded(flex: 3, child: aside),
              ],
            )
          else ...[
            title,
            const SizedBox(height: 20),
            aside,
          ],
        ],
      ),
    );
  }

  Widget _buildDesktopCollage(ThemeController theme) {
    // Rows are 3 wide, so plate index = row * 3 + column.
    return Column(
      children: [
        for (var r = 0; r < _collageRows.length; r++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var c = 0; c < 3; c++) ...[
                if (c > 0) const SizedBox(width: 32),
                Expanded(
                  flex: _collageRows[r][c].$1,
                  child: Padding(
                    padding: EdgeInsets.only(top: _collageRows[r][c].$3),
                    child: ArcoInView(
                      delay: Duration(milliseconds: 110 * c),
                      child: _CollageTile(
                        index: r * 3 + c,
                        photo: _editorialPhotos[r * 3 + c],
                        height: _collageRows[r][c].$2,
                        onTap: _openPhoto,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 72),
        ],
      ],
    );
  }

  Widget _buildMobileCollage(ThemeController theme) {
    return Column(
      children: [
        for (var i = 0; i < _editorialPhotos.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: ArcoInView(
              child: _CollageTile(index: i, photo: _editorialPhotos[i], height: i.isEven ? 420 : 300, onTap: _openPhoto),
            ),
          ),
      ],
    );
  }
}

/// One plate on the wall: photograph, number, title and story. No frame, no badges.
class _CollageTile extends StatefulWidget {
  final int index;
  final Map<String, String> photo;
  final double height;
  final ValueChanged<int> onTap;

  const _CollageTile({required this.index, required this.photo, required this.height, required this.onTap});

  @override
  State<_CollageTile> createState() => _CollageTileState();
}

class _CollageTileState extends State<_CollageTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final photo = widget.photo;
    return Semantics(
      button: true,
      label: 'Open photograph: ${photo['title']}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => widget.onTap(widget.index),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: widget.height,
                  width: double.infinity,
                  child: AnimatedScale(
                    scale: _hover ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    child: Image.asset(photo['asset']!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.index + 1).toString().padLeft(2, '0'),
                    style: AppTypography.scoreboard.copyWith(
                      fontSize: 11,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentOrange,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          photo['title']!,
                          style: AppTypography.headingSmall.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                            color: theme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          photo['caption']!,
                          style: AppTypography.scoreboard.copyWith(
                            fontSize: 10.5,
                            letterSpacing: 1.2,
                            color: theme.tertiaryText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          photo['story']!,
                          style: AppTypography.bodySmall.copyWith(height: 1.5, color: theme.secondaryText),
                        ),
                      ],
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
