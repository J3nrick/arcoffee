import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/badge_pill.dart';
import '../../../shared/widgets/frosted_glass_container.dart';
import '../../../shared/widgets/status_pill.dart';
import '../../../theme/theme_controller.dart';

/// Hero Section for Arcoffee: introduces the brand slogan, location, and court atmosphere.
class HomeHeroSection extends StatelessWidget {
  final VoidCallback onExploreMenu;
  final VoidCallback onViewLocation;

  const HomeHeroSection({
    super.key,
    required this.onExploreMenu,
    required this.onViewLocation,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final horizontalPad = Responsive.horizontalPadding(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPad,
        vertical: isDesktop ? 48.0 : 28.0,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: isDesktop ? _buildDesktopHero(context, theme) : _buildMobileHero(context, theme),
      ),
    );
  }

  Widget _buildDesktopHero(BuildContext context, ThemeController theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Main Typography & CTA
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Courtside Pill & Live Status
              const Row(
                children: [
                  BadgePill(
                    label: "THE PICKLEGROUND PH • KAWIT / NOVELETA",
                    icon: CupertinoIcons.sportscourt_fill,
                    backgroundColor: Color(0xFFF3ECE0),
                    textColor: AppColors.primaryBlue,
                  ),
                  SizedBox(width: 10),
                  StatusPill(
                    text: "WEEKENDS 24 HOURS",
                    isOpen: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Hero Title
              RichText(
                text: TextSpan(
                  style: AppTypography.largeTitle.copyWith(
                    fontSize: 48,
                    height: 1.12,
                    letterSpacing: -1.5,
                  ),
                  children: [
                    TextSpan(
                      text: "Where Coffee Fuels the ",
                      style: TextStyle(color: theme.primaryText),
                    ),
                    const TextSpan(
                      text: "Court.",
                      style: TextStyle(color: AppColors.accentOrange),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Slogan Callout
              Text(
                "\"${AppConstants.slogan}\"",
                style: AppTypography.brandSlogan.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                "Arcoffee brings high-octane community energy and specialty craft beverages right to the baseline of The Pickleground PH. From cold brew endurance to viral Haw-Haw Matcha and fizzy Italian sodas, every cup is crafted for winners.",
                style: AppTypography.body.copyWith(
                  color: theme.secondaryText,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(16),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    onPressed: onExploreMenu,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.sparkles, size: 16, color: AppColors.pureWhite),
                        SizedBox(width: 8),
                        Text(
                          "Explore Menu Series",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.pureWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  CupertinoButton(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.isMidnightCourt ? const Color(0x33FFFFFF) : AppColors.primaryBlue.withOpacity(0.08),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    onPressed: onViewLocation,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.location_solid, size: 16, color: theme.isMidnightCourt ? AppColors.accentOrange : AppColors.primaryBlue),
                        const SizedBox(width: 8),
                        Text(
                          "Court Hours & Location",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: theme.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 48),

        // Right Column: Apple HIG Frosted Showcase Graphic Card
        Expanded(
          flex: 5,
          child: _buildShowcaseCard(),
        ),
      ],
    );
  }

  Widget _buildMobileHero(BuildContext context, ThemeController theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            BadgePill(
              label: "THE PICKLEGROUND PH",
              icon: CupertinoIcons.sportscourt_fill,
              backgroundColor: Color(0xFFF3ECE0),
              textColor: AppColors.primaryBlue,
              isSmall: true,
            ),
            StatusPill(
              text: "FRI-SUN 24 HOURS",
              isOpen: true,
            ),
          ],
        ),
        const SizedBox(height: 18),
        RichText(
          text: TextSpan(
            style: AppTypography.largeTitle.copyWith(
              fontSize: 34,
              height: 1.15,
              letterSpacing: -1.0,
            ),
            children: [
              TextSpan(
                text: "Where Coffee Fuels the ",
                style: TextStyle(color: theme.primaryText),
              ),
              const TextSpan(
                text: "Court.",
                style: TextStyle(color: AppColors.accentOrange),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "\"${AppConstants.slogan}\"",
          style: AppTypography.brandSlogan.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Cavite's premier courtside sanctuary. Serving handcrafted coffee, viral Haw-Haw Matcha, and sparkling craft sodas.",
          style: AppTypography.callout.copyWith(
            color: theme.secondaryText,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: CupertinoButton.filled(
                borderRadius: BorderRadius.circular(14),
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: onExploreMenu,
                child: const Text(
                  "Explore Menu",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.pureWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.primaryBlue.withOpacity(0.08),
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: onViewLocation,
                child: const Text(
                  "Hours & Loc",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        _buildShowcaseCard(),
      ],
    );
  }

  Widget _buildShowcaseCard() {
    return FrostedGlassContainer(
      borderRadius: 24,
      backgroundColor: AppColors.pureWhite.withOpacity(0.85),
      borderColor: AppColors.borderLight,
      padding: const EdgeInsets.all(24),
      shadow: BoxShadow(
        color: AppColors.primaryBlue.withOpacity(0.08),
        blurRadius: 32,
        offset: const Offset(0, 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphic header
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryBlue,
                  Color(0xFF1E3A56),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              children: [
                // Stylized Pickleball Court Courtlines
                Positioned(
                  left: 20,
                  top: 0,
                  bottom: 0,
                  width: 2,
                  child: Container(color: AppColors.pureWhite.withOpacity(0.2)),
                ),
                Positioned(
                  right: 20,
                  top: 0,
                  bottom: 0,
                  width: 2,
                  child: Container(color: AppColors.pureWhite.withOpacity(0.2)),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 90,
                  height: 2,
                  child: Container(color: AppColors.courtOrange.withOpacity(0.5)),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentOrange.withOpacity(0.4),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.sportscourt_fill,
                          size: 32,
                          color: AppColors.pureWhite,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "THE PICKLEGROUND PH",
                        style: TextStyle(
                          color: AppColors.pureWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Home of Arcoffee • Kawit / Noveleta",
                        style: AppTypography.caption1.copyWith(
                          color: AppColors.pureWhite.withOpacity(0.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Feature Grid Row inside Card
          Row(
            children: [
              _buildFeatureMini(
                CupertinoIcons.flame_fill,
                "Espresso Craft",
                "Spanish & Macchiato",
                AppColors.warmCoffee,
              ),
              const SizedBox(width: 12),
              _buildFeatureMini(
                CupertinoIcons.leaf_arrow_circlepath,
                "Haw-Haw Matcha",
                "Viral Cavite Hit",
                AppColors.matchaGreen,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFeatureMini(
                CupertinoIcons.burst_fill,
                "Fizzy Sodas",
                "Lychee & Lemon Yuzu",
                AppColors.sodaBlue,
              ),
              const SizedBox(width: 12),
              _buildFeatureMini(
                CupertinoIcons.moon_stars_fill,
                "24H Weekend",
                "Fri - Sun All Night",
                AppColors.accentOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureMini(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withOpacity(0.18),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.caption1.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.caption2.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
