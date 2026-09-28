import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_typography.dart';
import '../../../core/utils/image_precacher.dart';
import '../../../data/repositories/gallery_repository.dart';
import '../../../shared/components/arco_court_line.dart';
import '../../../theme/theme_controller.dart';

/// "The Arcoffee Wall" Editorial Collage Section.
/// Showcases all authentic courtside & lifestyle photographs with interactive full-screen lightbox.
class GalleryView extends StatefulWidget {
  final GalleryRepository repository;

  const GalleryView({super.key, required this.repository});

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

  void _openImageLightbox(BuildContext context, Map<String, String> photo) {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return Container(
          color: AppColors.deepBlue.withValues(alpha: 0.96),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(
                    maxScale: 3.5,
                    child: photo['asset'] != null
                        ? Image.asset(photo['asset']!, fit: BoxFit.contain)
                        : Image.network(photo['url'] ?? '', fit: BoxFit.contain),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: CupertinoButton(
                    color: AppColors.accentOrange,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      "CLOSE ✕",
                      style: TextStyle(
                        fontFamily: AppTypography.displayFont,
                        fontWeight: FontWeight.w800,
                        color: AppColors.pureWhite,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.deepBlue.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.accentOrange.withValues(alpha: 0.4),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          photo['caption']!,
                          style: TextStyle(
                            fontFamily: AppTypography.scoreboardFont,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: AppColors.accentOrange,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          photo['story']!,
                          style: TextStyle(
                            fontFamily: AppTypography.bodyFont,
                            fontSize: 13,
                            color: AppColors.pureWhite,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final horizontalPad = AppBreakpoints.horizontalPadding(context);

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: CupertinoActivityIndicator(radius: 16),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isDesktop ? 64.0 : 36.0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header & Brand Monospaced Label
            Text(
              "AR / 003   |   THE ARCOFFEE WALL (EDITORIAL COLLAGE)",
              style: AppTypography.scoreboard.copyWith(
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
              ),
            ),
            const SizedBox(height: 12),
            ArcoCourtLine(
              width: double.infinity,
              height: 1.2,
              color: isDark ? AppColors.courtLineNight : AppColors.courtLineDay,
            ),
            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    "Good Coffee. Good People. Good Games.",
                    style: AppTypography.display.copyWith(
                      color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                      fontSize: isDesktop ? 36 : 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  "[ EXPAND FULLSCREEN ]",
                  style: TextStyle(
                    fontFamily: AppTypography.monoFont,
                    fontFamilyFallback: AppTypography.monoFontFallback,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                    color: AppColors.accentOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Editorial Asymmetric Photo Collage (3 Dynamic Rows)
            if (isDesktop)
              _buildDesktopEditorialCollage(isDark)
            else
              _buildMobileCollage(isDark),
          ],
        ),
      ),
    );
  }

  /// Desktop Asymmetrical Collage across 3 dynamic rows
  Widget _buildDesktopEditorialCollage(bool isDark) {
    return Column(
      children: [
        // Row 1
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: _buildCollageTile(
                photo: _editorialPhotos[0],
                isDark: isDark,
                height: 380,
                topOffset: 0,
              ),
            ),
            const SizedBox(width: 28),
            Expanded(
              flex: 3,
              child: _buildCollageTile(
                photo: _editorialPhotos[1],
                isDark: isDark,
                height: 320,
                topOffset: 48,
              ),
            ),
            const SizedBox(width: 28),
            Expanded(
              flex: 4,
              child: _buildCollageTile(
                photo: _editorialPhotos[2],
                isDark: isDark,
                height: 360,
                topOffset: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),

        // Row 2
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _buildCollageTile(
                photo: _editorialPhotos[3],
                isDark: isDark,
                height: 340,
                topOffset: 24,
              ),
            ),
            const SizedBox(width: 28),
            Expanded(
              flex: 4,
              child: _buildCollageTile(
                photo: _editorialPhotos[4],
                isDark: isDark,
                height: 380,
                topOffset: 0,
              ),
            ),
            const SizedBox(width: 28),
            Expanded(
              flex: 4,
              child: _buildCollageTile(
                photo: _editorialPhotos[5],
                isDark: isDark,
                height: 350,
                topOffset: 40,
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),

        // Row 3
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: _buildCollageTile(
                photo: _editorialPhotos[6],
                isDark: isDark,
                height: 350,
                topOffset: 0,
              ),
            ),
            const SizedBox(width: 28),
            Expanded(
              flex: 4,
              child: _buildCollageTile(
                photo: _editorialPhotos[7],
                isDark: isDark,
                height: 380,
                topOffset: 30,
              ),
            ),
            const SizedBox(width: 28),
            Expanded(
              flex: 3,
              child: _buildCollageTile(
                photo: _editorialPhotos[8],
                isDark: isDark,
                height: 330,
                topOffset: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Mobile Stacked Collage
  Widget _buildMobileCollage(bool isDark) {
    return Column(
      children: _editorialPhotos.map((photo) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: _buildCollageTile(
            photo: photo,
            isDark: isDark,
            height: 260,
            topOffset: 0,
          ),
        );
      }).toList(),
    );
  }

  /// Individual Editorial Photo Tile with Monospaced Metadata & Lightbox Tap
  Widget _buildCollageTile({
    required Map<String, String> photo,
    required bool isDark,
    required double height,
    required double topOffset,
  }) {
    return Container(
      margin: EdgeInsets.only(top: topOffset),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _openImageLightbox(context, photo),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photography Box with Depth & Hover Lift
              Container(
                height: height,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withValues(alpha: 0.12),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepBlue.withValues(alpha: isDark ? 0.35 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      photo['asset'] != null
                          ? Image.asset(
                              photo['asset']!,
                              fit: BoxFit.cover,
                            )
                          : ArcoffeeNetworkImage(
                              imageUrl: photo['url'] ?? '',
                              fit: BoxFit.cover,
                              borderRadius: 16,
                            ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.deepBlue.withValues(alpha: 0.75),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            CupertinoIcons.viewfinder,
                            size: 14,
                            color: AppColors.pureWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Monospaced Timestamp / Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    photo['caption']!,
                    style: AppTypography.scoreboard.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.accentOrange,
                    ),
                  ),
                  Text(
                    photo['title']!,
                    style: AppTypography.receipt.copyWith(
                      fontSize: 10,
                      letterSpacing: 0.8,
                      color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Story Text
              Text(
                photo['story']!,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
