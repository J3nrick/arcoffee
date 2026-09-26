import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_typography.dart';
import '../../../core/utils/image_precacher.dart';
import '../../../data/models/store_info.dart';
import '../../../data/repositories/store_repository.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_court_line.dart';
import '../../../shared/components/arco_logo.dart';
import '../../../theme/theme_controller.dart';

/// Editorial Location & Operating Hours Section for Arcoffee.
/// Implements the exact blueprint: Left side narrative & 24H hours,
/// Right side stylized court location photograph and Waze/Maps CTA.
class LocationView extends StatefulWidget {
  final StoreRepository repository;

  const LocationView({super.key, required this.repository});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  StoreInfo? _storeInfo;
  bool _isOpenNow = true;
  bool _isLoading = true;

  // Real location photo representation: The Pickleground PH outdoor court & coffee bar
  static const String _courtLocationImageUrl =
      'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=1000&q=85';

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
    final horizontalPad = AppBreakpoints.horizontalPadding(context);
    final isDesktop = AppBreakpoints.isDesktop(context);
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: CupertinoActivityIndicator(radius: 16),
        ),
      );
    }

    final store = _storeInfo!;

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
              "AR / 004   |   FIND US AT THE COURT",
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
            const SizedBox(height: 36),

            // Editorial Asymmetric Layout
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Venue Details, Operating Hours, Status & CTA (50% Width)
                  Expanded(
                    flex: 50,
                    child: _buildLocationStory(store, isDark),
                  ),
                  const SizedBox(width: 56),

                  // Right Side: Location Photograph & Court Coordinates (50% Width)
                  Expanded(
                    flex: 50,
                    child: _buildLocationPhotoCard(isDark),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationStory(store, isDark),
                  const SizedBox(height: 36),
                  _buildLocationPhotoCard(isDark, height: 260),
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Left Side Narrative: Venue, Hours, Open Status, and Directions Action
  Widget _buildLocationStory(StoreInfo store, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Venue Title
        Text(
          store.venue.toUpperCase(),
          style: AppTypography.headingXL.copyWith(
            fontSize: 32,
            letterSpacing: -1.0,
            fontWeight: FontWeight.w900,
            color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
          ),
        ),
        const SizedBox(height: 8),

        // Address
        Text(
          "${store.address}, ${store.province}",
          style: AppTypography.bodyLarge.copyWith(
            fontSize: 16,
            color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Beside major Kawit/Noveleta transit corridors with direct Cavitex access.",
          style: AppTypography.receipt.copyWith(
            fontSize: 12,
            color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay,
          ),
        ),
        const SizedBox(height: 28),

        // Court Hairline Separator
        ArcoCourtLine(
          width: 240,
          height: 1.0,
          color: isDark ? AppColors.courtLineNight : AppColors.courtLineDay,
        ),
        const SizedBox(height: 28),

        // Operating Schedule
        Text(
          "OPERATING HOURS",
          style: AppTypography.scoreboard.copyWith(
            fontSize: 11,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: AppColors.accentOrange,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "MON – THU",
              style: AppTypography.headingSmall.copyWith(
                color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
              ),
            ),
            Text(
              "2:00 PM – 10:00 PM",
              style: AppTypography.scoreboard.copyWith(
                color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "FRI – SUN",
              style: AppTypography.headingSmall.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.accentOrange,
              ),
            ),
            Text(
              "24 HOURS (NON-STOP)",
              style: AppTypography.scoreboard.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.accentOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Live Open Status (Clean typography with dot indicator, NO emojis)
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _isOpenNow ? AppColors.statusOpen : AppColors.statusClosed,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _isOpenNow ? "OPEN NOW • COURT & BAR ACTIVE" : "CLOSED NOW",
              style: AppTypography.scoreboard.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: _isOpenNow ? AppColors.statusOpen : AppColors.statusClosed,
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),

        // Directions Button
        ArcoButton(
          text: "Get Directions via Waze / Maps →",
          onPressed: () {},
          variant: ArcoButtonVariant.primary,
        ),
      ],
    );
  }

  /// Right Side Location Photograph & Court Geometry Overlay
  Widget _buildLocationPhotoCard(bool isDark, {double height = 380}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withOpacity(0.08),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withOpacity(isDark ? 0.35 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ArcoffeeNetworkImage(
              imageUrl: _courtLocationImageUrl,
              fit: BoxFit.cover,
              borderRadius: 20,
            ),
            // Dark gradient overlay for metadata legibility
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 90,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.deepBlue.withOpacity(0.8),
                      AppColors.deepBlue.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Top Right Official Logo Brand Mark
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xCC07111D) : AppColors.deepBlue.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const ArcoLogo(
                  height: 16,
                  showText: false,
                  color: AppColors.pureWhite,
                ),
              ),
            ),
            // Bottom Coordinates Caption
            Positioned(
              bottom: 16,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "COORDINATES: 14.4445° N, 120.9038° E",
                    style: AppTypography.scoreboard.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  Text(
                    "THE PICKLEGROUND PH / KAWIT, CAVITE",
                    style: AppTypography.receipt.copyWith(
                      fontSize: 10,
                      color: AppColors.softSand,
                    ),
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
