import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_motion.dart';
import '../../../core/design/app_radii.dart';
import '../../../core/design/app_typography.dart';
import '../../../core/utils/image_precacher.dart';
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

  // Curated hero photography: Iced coffee on textured outdoor court surface under golden hour sunlight
  static const String _heroImageUrl =
      'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=1200&q=85';

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

  /// Right-side Full-Bleed Editorial Photograph with Overlapping Tilted Sticker
  Widget _buildEditorialPhotoFocalPoint(ThemeController theme, bool isDark, {required double height}) {
    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Full-Bleed Photograph
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepBlue.withOpacity(isDark ? 0.45 : 0.14),
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
                    ArcoffeeNetworkImage(
                      imageUrl: _heroImageUrl,
                      fit: BoxFit.cover,
                      borderRadius: 20,
                    ),
                    // Subtle bottom gradient vignette for metadata contrast
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 80,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.deepBlue.withOpacity(0.75),
                              AppColors.deepBlue.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Bottom Metadata Caption on Image
                    Positioned(
                      bottom: 16,
                      right: 18,
                      child: Text(
                        "KAWIT, CAVITE  /  SATURDAY 08:42 PM",
                        style: AppTypography.receipt.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.pureWhite,
                        ),
                      ),
                    ),
                  ],
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
                      color: AppColors.deepBlue.withOpacity(0.28),
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
