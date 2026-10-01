import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/responsive.dart';
import 'badge_pill.dart';

/// Clean, segmented footer adhering to Apple HIG layout patterns.
class FooterView extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const FooterView({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        border: Border(
          top: BorderSide(
            color: AppColors.borderLight,
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: 48,
      ),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
            child: isDesktop
                ? _buildDesktopFooterContent(context)
                : _buildMobileFooterContent(context),
          ),
          Container(
            height: 1,
            color: const Color(0x24FFFFFF),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "© ${DateTime.now().year} Arcoffee PH. All rights reserved.",
                  style: AppTypography.footnote.copyWith(
                    color: AppColors.textInverse.withValues(alpha: 0.6),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Crafted with Apple HIG & Flutter",
                      style: AppTypography.caption2.copyWith(
                        color: AppColors.textInverse.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooterContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand & Slogan
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "ar",
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "ARCOFFEE",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textInverse,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "\"It's always been ours.\"",
                style: AppTypography.brandSlogan.copyWith(
                  color: AppColors.accentOrange,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "The sports-centric coffee destination located right inside The Pickleground PH. Fueling rallies, late-night runs, and community connections.",
                style: AppTypography.callout.copyWith(
                  color: AppColors.textInverse.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 16),
              const BadgePill(
                label: "PICKLEBALL COURTSIDE",
                icon: CupertinoIcons.sportscourt_fill,
                backgroundColor: Color(0x33FF6600),
                textColor: AppColors.courtOrange,
              ),
            ],
          ),
        ),
        const SizedBox(width: 48),

        // Quick Navigation
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NAVIGATION",
                style: AppTypography.caption2.copyWith(
                  color: AppColors.textInverse.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              _footerNavLink("Home", () => onNavigate(0)),
              _footerNavLink("Menu Highlights", () => onNavigate(1)),
              _footerNavLink("Community Gallery", () => onNavigate(2)),
              _footerNavLink("Location & Hours", () => onNavigate(3)),
            ],
          ),
        ),

        // Operating Hours
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "OPERATING HOURS",
                style: AppTypography.caption2.copyWith(
                  color: AppColors.textInverse.withValues(alpha: 0.5),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              _buildHourRow(
                "Monday – Thursday",
                "2:00 PM – 10:00 PM",
                isHighlight: false,
              ),
              const SizedBox(height: 10),
              _buildHourRow(
                "Friday – Sunday",
                "24 Hours (Non-Stop)",
                isHighlight: true,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.location_solid,
                    size: 14,
                    color: AppColors.accentOrange,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "The Pickleground PH, Kawit/Noveleta, Cavite",
                      style: AppTypography.footnote.copyWith(
                        color: AppColors.textInverse.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFooterContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accentOrange,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                "ar",
                style: TextStyle(
                  color: AppColors.pureWhite,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "ARCOFFEE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textInverse,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          "\"It's always been ours.\"",
          style: AppTypography.brandSlogan.copyWith(
            color: AppColors.accentOrange,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "OPERATING HOURS",
          style: AppTypography.caption2.copyWith(
            color: AppColors.textInverse.withValues(alpha: 0.5),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _buildHourRow("Mon – Thu", "2:00 PM – 10:00 PM", isHighlight: false),
        const SizedBox(height: 8),
        _buildHourRow("Fri – Sun", "24 Hours Non-Stop", isHighlight: true),
        const SizedBox(height: 24),
        Text(
          "LOCATION",
          style: AppTypography.caption2.copyWith(
            color: AppColors.textInverse.withValues(alpha: 0.5),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "The Pickleground PH, Kawit / Noveleta, Cavite",
          style: AppTypography.callout.copyWith(
            color: AppColors.textInverse.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(32, 32),
              onPressed: () => onNavigate(1),
              child: const Text(
                "View Menu",
                style: TextStyle(color: AppColors.accentOrange, fontSize: 14),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size(32, 32),
              onPressed: () => onNavigate(3),
              child: Text(
                "Find Us",
                style: TextStyle(color: AppColors.textInverse.withValues(alpha: 0.8), fontSize: 14),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _footerNavLink(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            title,
            style: AppTypography.callout.copyWith(
              color: AppColors.textInverse.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHourRow(String days, String hours, {required bool isHighlight}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isHighlight ? AppColors.accentOrange.withValues(alpha: 0.18) : const Color(0x12FFFFFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlight ? AppColors.accentOrange.withValues(alpha: 0.4) : const Color(0x18FFFFFF),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            days,
            style: AppTypography.footnote.copyWith(
              color: AppColors.textInverse.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            hours,
            style: AppTypography.footnote.copyWith(
              color: isHighlight ? AppColors.accentOrange : AppColors.textInverse,
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
