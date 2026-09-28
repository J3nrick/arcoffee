import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_motion.dart';
import '../../../core/design/app_typography.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_court_line.dart';
import '../../../shared/components/arco_logo.dart';
import '../../../theme/theme_controller.dart';

/// Editorial Asymmetrical Hero Section for Arcoffee.
/// Implements the exact 45% (Story) / 55% (Photography) layout blueprint
/// with zero emojis, full-bleed coffee campaign photo, and overlapping brand sticker.
class HomeHeroSection extends StatefulWidget {
  final VoidCallback onExploreMenu;
  final VoidCallback onViewLocation;

  const HomeHeroSection({
    super.key,
    required this.onExploreMenu,
    required this.onViewLocation,
  });

  @override
  State<HomeHeroSection> createState() => _HomeHeroSectionState();
}

class _HomeHeroSectionState extends State<HomeHeroSection> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  // Curated hero photography: Curated authentic courtside shots
  int _activeHeroPhotoIndex = 0;

  static const List<Map<String, String>> _heroPhotos = [
    {
      'asset': 'assets/images/milo_overload_court.png',
      'num': '01',
      'title': 'MILO OVERLOAD ON COURT BASELINE',
      'caption': 'THE PICKLEGROUND PH • COURT BASELINE',
      'story': 'Signature chilled malt beverage topped with thick Milo powder overload, shot courtside at The Pickleground PH.',
    },
    {
      'asset': 'assets/images/court_arena_drink.jpg',
      'num': '02',
      'title': 'INDOOR ARENA & ESPRESSO BAR',
      'caption': 'THE PICKLEGROUND PH • KAWIT ARENA',
      'story': 'Full view of the active indoor pickleball tournament courts and the Arcoffee espresso bar in Kawit, Cavite.',
    },
    {
      'asset': 'assets/images/green_apple_court_line.jpg',
      'num': '03',
      'title': 'GREEN APPLE CRAFT SODA',
      'caption': 'COURT NON-VOLLEY LINE • CHILLED',
      'story': 'Crisp, sparkling house-crafted green apple soda served ice-cold directly on the tournament court line.',
    },
    {
      'asset': 'assets/images/lychee_soda_chat_paddle.jpg',
      'num': '04',
      'title': 'POST-RALLY CHAT & PADDLE',
      'caption': 'COMMUNITY BENCH • SIDELINE SESSIONS',
      'story': 'Arcoffee refreshing sparkling lychee soda on the player bench beside a graphite pickleball paddle after an intense rally.',
    },
  ];

  void _openHeroLightbox(BuildContext context, int index) {
    final photo = _heroPhotos[index];
    showCupertinoModalPopup<void>(
      context: context,
      barrierColor: const Color(0xE607111D),
      builder: (ctx) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880, maxHeight: 720),
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1B28),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.accentOrange.withValues(alpha: 0.4),
                  width: 1.2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 3.5,
                      child: Center(
                        child: Image.asset(
                          photo['asset']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 36,
                        borderRadius: BorderRadius.circular(18),
                        color: AppColors.deepBlue.withValues(alpha: 0.8),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          color: AppColors.pureWhite,
                          size: 18,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.deepBlue.withValues(alpha: 0.88),
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
                              photo['title']!,
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
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isDesktop = AppBreakpoints.isDesktop(context);
    final horizontalPad = AppBreakpoints.horizontalPadding(context);
    final isReducedMotion = AppMotion.isReducedMotion(context);

    Widget content = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isDesktop ? 56.0 : 28.0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: isDesktop
            ? _buildDesktopAsymmetricHero(theme, isDark)
            : _buildMobileEditorialHero(theme, isDark),
      ),
    );

    if (isReducedMotion) return content;

    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideUp,
        child: content,
      ),
    );
  }

  /// 45% (Text) / 55% (Image) Asymmetrical Desktop Layout
  Widget _buildDesktopAsymmetricHero(ThemeController theme, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // LEFT COLUMN (45% Width): Story, Metadata, Bold Typography, CTAs
        Expanded(
          flex: 45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Brand Monospaced Metadata & Logo Mark
              Row(
                children: [
                  ArcoLogo(
                    height: 20,
                    showText: false,
                    color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "AR / 001   |   THE PICKLEGROUND PH",
                    style: AppTypography.scoreboard.copyWith(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ArcoCourtLine(
                width: 240,
                height: 1.2,
                color: isDark ? AppColors.courtLineNight : AppColors.courtLineDay,
              ),
              const SizedBox(height: 28),

              // Massive Editorial Headline (Graphic Element)
              Text(
                "COFFEE,\nCOURT-SIDE.",
                style: AppTypography.displayXL.copyWith(
                  fontSize: 68,
                  height: 0.96,
                  letterSpacing: -2.2,
                  fontWeight: FontWeight.w900,
                  color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                ),
              ),
              const SizedBox(height: 18),

              // Tagline
              Text(
                "\"${AppConstants.slogan}\"",
                style: AppTypography.bodyLarge.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: AppColors.accentOrange,
                ),
              ),
              const SizedBox(height: 14),

              // Editorial Narrative Description
              Text(
                "Craft specialty coffee, non-coffee overloads & ice-cold sodas served directly alongside the pickleball courts in Kawit, Cavite.",
                style: AppTypography.bodyLarge.copyWith(
                  fontSize: 16,
                  height: 1.5,
                  color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                ),
              ),
              const SizedBox(height: 36),

              // Action Buttons
              Row(
                children: [
                  ArcoButton(
                    text: "Explore Menu →",
                    onPressed: widget.onExploreMenu,
                    variant: ArcoButtonVariant.primary,
                  ),
                  const SizedBox(width: 16),
                  ArcoButton(
                    text: "Location & Hours",
                    onPressed: widget.onViewLocation,
                    variant: ArcoButtonVariant.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 48),

        // RIGHT COLUMN (55% Width): Massive Editorial Photograph & Overlapping Brand Sticker
        Expanded(
          flex: 55,
          child: _buildEditorialPhotoFocalPoint(theme, isDark, height: 460),
        ),
      ],
    );
  }

  /// Mobile Stacked Editorial Composition
  Widget _buildMobileEditorialHero(ThemeController theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand Monospaced Metadata & Logo Mark
        Row(
          children: [
            ArcoLogo(
              height: 18,
              showText: false,
              color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
            ),
            const SizedBox(width: 10),
            Text(
              "AR / 001   |   THE PICKLEGROUND PH",
              style: AppTypography.scoreboard.copyWith(
                fontSize: 11,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.accentOrange : AppColors.deepBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ArcoCourtLine(
          width: 180,
          height: 1.0,
          color: isDark ? AppColors.courtLineNight : AppColors.courtLineDay,
        ),
        const SizedBox(height: 20),

        // Headline
        Text(
          "COFFEE,\nCOURT-SIDE.",
          style: AppTypography.displayXL.copyWith(
            fontSize: 42,
            height: 0.98,
            letterSpacing: -1.4,
            color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
          ),
        ),
        const SizedBox(height: 12),

        // Tagline
        Text(
          "\"${AppConstants.slogan}\"",
          style: AppTypography.body.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            color: AppColors.accentOrange,
          ),
        ),
        const SizedBox(height: 24),

        // Photography Focal Point
        _buildEditorialPhotoFocalPoint(theme, isDark, height: 260),
        const SizedBox(height: 20),

        // Description
        Text(
          "Craft specialty coffee, non-coffee overloads & ice-cold sodas served directly alongside the courts in Kawit, Cavite.",
          style: AppTypography.body.copyWith(
            color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
          ),
        ),
        const SizedBox(height: 28),

        // Full-width buttons for mobile
        Row(
          children: [
            Expanded(
              child: ArcoButton(
                text: "Explore Menu →",
                onPressed: widget.onExploreMenu,
                variant: ArcoButtonVariant.primary,
                isFullWidth: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ArcoButton(
                text: "Location",
                onPressed: widget.onViewLocation,
                variant: ArcoButtonVariant.secondary,
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Right-side Full-Bleed Editorial Photograph with Overlapping Tilted Sticker & Switcher
  Widget _buildEditorialPhotoFocalPoint(ThemeController theme, bool isDark, {required double height}) {
    final activePhoto = _heroPhotos[_activeHeroPhotoIndex];

    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Full-Bleed Photograph with Interactive Tap-to-Enlarge
          Positioned.fill(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _openHeroLightbox(context, _activeHeroPhotoIndex),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepBlue.withValues(alpha: isDark ? 0.45 : 0.14),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: SizedBox.expand(
                            key: ValueKey<String>(activePhoto['asset']!),
                            child: Image.asset(
                              activePhoto['asset']!,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        // Subtle bottom gradient vignette for metadata contrast
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 110,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  AppColors.deepBlue.withValues(alpha: 0.88),
                                  AppColors.deepBlue.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Top bar: Editorial Photo Carousel Switcher Tabs (01, 02, 03, 04)
                        Positioned(
                          top: 14,
                          right: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.deepBlue.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDark ? const Color(0x33FFFFFF) : AppColors.softSand.withValues(alpha: 0.3),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(_heroPhotos.length, (idx) {
                                final isSelected = idx == _activeHeroPhotoIndex;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _activeHeroPhotoIndex = idx;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.accentOrange : CupertinoColors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _heroPhotos[idx]['num']!,
                                      style: TextStyle(
                                        fontFamily: AppTypography.monoFont,
                                        fontFamilyFallback: AppTypography.monoFontFallback,
                                        fontSize: 11,
                                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                        color: isSelected ? AppColors.pureWhite : AppColors.softSand,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        // Top Left: Expand Indicator
                        Positioned(
                          top: 14,
                          left: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.deepBlue.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "[ VIEW FULLSCREEN ]",
                              style: TextStyle(
                                fontFamily: AppTypography.monoFont,
                                fontFamilyFallback: AppTypography.monoFontFallback,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: AppColors.accentOrange,
                              ),
                            ),
                          ),
                        ),
                        // Bottom Metadata Caption on Image
                        Positioned(
                          bottom: 16,
                          right: 18,
                          left: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                activePhoto['title']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: AppTypography.scoreboardFont,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: AppColors.accentOrange,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                activePhoto['caption']!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.receipt.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.6,
                                  color: AppColors.pureWhite,
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
            ),
          ),

          // Tilted Brand Sticker Overlapping the Left Edge
          Positioned(
            bottom: -14,
            left: -14,
            child: Transform.rotate(
              angle: -0.04,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepBlue.withValues(alpha: 0.28),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ArcoLogo(
                      height: 18,
                      showText: false,
                      color: AppColors.pureWhite,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "PLAY.",
                      style: AppTypography.scoreboard.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.pureWhite,
                        letterSpacing: 1.0,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      "SIP.",
                      style: AppTypography.scoreboard.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.pureWhite,
                        letterSpacing: 1.0,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      "REPEAT.",
                      style: AppTypography.scoreboard.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.pureWhite,
                        letterSpacing: 1.0,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
