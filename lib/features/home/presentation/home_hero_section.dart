import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_motion.dart';
import '../../../core/design/app_typography.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_court_line.dart';
import '../../../shared/components/arco_metadata.dart';
import '../../../shared/components/arco_sticker.dart';
import '../../../theme/theme_controller.dart';

/// Editorial Hero Section for Arcoffee ("Court-side coffee culture").
/// Features bold display typography, court line geometry, integrated graphics, and calm entrance.
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

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppMotion.hero,
    );

    _fadeIn = CurvedAnimation(
      parent: _animController,
      curve: AppMotion.heroCurve,
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: AppMotion.heroCurve,
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
        vertical: isDesktop ? 64.0 : 32.0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: isDesktop
            ? _buildDesktopComposition(theme, isDark)
            : _buildMobileComposition(theme, isDark),
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

  Widget _buildDesktopComposition(ThemeController theme, bool isDark) {
    return ArcoCornerBracket(
      size: 24,
      strokeWidth: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Column: Editorial Headline & Actions
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const ArcoSticker(text: "THE PICKLEGROUND PH", rotation: -0.02),
                      const SizedBox(width: 12),
                      ArcoScoreboardMetadata(
                        label: "HOURS",
                        value: isDark ? "24H NIGHT SESSION" : "MON-THU 2-10PM | FRI-SUN 24H",
                        isHighlight: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Display Headline
                  Text(
                    "COFFEE,\nCOURT-SIDE.",
                    style: AppTypography.displayXL.copyWith(
                      color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                      fontSize: 64,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "\"${AppConstants.slogan}\"",
                    style: AppTypography.bodyLarge.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      color: AppColors.accentOrange,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    "Craft specialty coffee, non-coffee overloads & ice-cold sodas served directly alongside the pickleball courts in Kawit, Cavite.",
                    style: AppTypography.bodyLarge.copyWith(
                      color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      ArcoButton(
                        text: "Explore Menu",
                        icon: CupertinoIcons.flame_fill,
                        onPressed: widget.onExploreMenu,
                        variant: ArcoButtonVariant.primary,
                      ),
                      const SizedBox(width: 16),
                      ArcoButton(
                        text: "Location & Hours",
                        icon: CupertinoIcons.location_fill,
                        onPressed: widget.onViewLocation,
                        variant: ArcoButtonVariant.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48),

            // Right Column: Integrated Graphic Hero Display
            Expanded(
              flex: 5,
              child: _buildHeroGraphicDisplay(theme, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileComposition(ThemeController theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ArcoSticker(text: "COURT SIDE COFFEE", rotation: -0.02),
        const SizedBox(height: 16),
        Text(
          "COFFEE,\nCOURT-SIDE.",
          style: AppTypography.displayXL.copyWith(
            color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
            fontSize: 42,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "\"${AppConstants.slogan}\"",
          style: AppTypography.body.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            color: AppColors.accentOrange,
          ),
        ),
        const SizedBox(height: 20),
        _buildHeroGraphicDisplay(theme, isDark, height: 220),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ArcoButton(
                text: "Explore Menu",
                icon: CupertinoIcons.flame_fill,
                onPressed: widget.onExploreMenu,
                variant: ArcoButtonVariant.primary,
                isFullWidth: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ArcoButton(
                text: "Location",
                icon: CupertinoIcons.location_fill,
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

  Widget _buildHeroGraphicDisplay(ThemeController theme, bool isDark, {double height = 360}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1D2B) : AppColors.softSand,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withOpacity(0.12),
          width: 1.2,
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 20,
            left: 20,
            child: ArcoCourtLine(width: 100, height: 1.0),
          ),
          const Positioned(
            top: 20,
            left: 20,
            child: ArcoCourtLine(width: 1.0, height: 80, isVertical: true),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentOrange.withOpacity(0.4),
                        blurRadius: 28,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    CupertinoIcons.circle_grid_hex_fill,
                    size: 44,
                    color: AppColors.pureWhite,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "MILO OVERLOAD & EXPRESSO RUSH",
                  style: AppTypography.scoreboard.copyWith(
                    fontSize: 12,
                    color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                  ),
                ),
                const SizedBox(height: 6),
                const ArcoSticker(text: "PLAY. SIP. REPEAT.", rotation: 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
