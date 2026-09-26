import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_radii.dart';
import '../../../core/design/app_shadows.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/models/store_info.dart';
import '../../../data/repositories/store_repository.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_court_line.dart';
import '../../../shared/components/arco_metadata.dart';
import '../../../shared/components/arco_sticker.dart';
import '../../../theme/theme_controller.dart';

/// Branded Location & Operating Hours View for Arcoffee.
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
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 36),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ArcoSticker(text: "THE PICKLEGROUND PH", rotation: -0.01),
                    const SizedBox(height: 8),
                    Text(
                      "Visit Arcoffee",
                      style: AppTypography.display.copyWith(
                        color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Located directly at The Pickleground PH in Kawit / Noveleta, Cavite.",
                      style: AppTypography.bodyLarge.copyWith(
                        color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                      ),
                    ),
                  ],
                ),
                ArcoScoreboardMetadata(
                  label: "STATUS",
                  value: _isOpenNow ? "OPEN NOW" : "CLOSED NOW",
                  isHighlight: _isOpenNow,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Grid Layout
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildHoursAndDetails(store, theme, isDark)),
                  const SizedBox(width: 24),
                  Expanded(flex: 5, child: _buildMapVisualCard(store, theme, isDark)),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHoursAndDetails(store, theme, isDark),
                  const SizedBox(height: 24),
                  _buildMapVisualCard(store, theme, isDark),
                ],
              ),

            const SizedBox(height: 32),
            _buildAmenitiesSection(store, theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursAndDetails(StoreInfo store, ThemeController theme, bool isDark) {
    final cardBg = isDark ? AppColors.surfaceNightL2 : AppColors.surfaceDayL2;

    return Column(
      children: [
        // Hours Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: AppRadii.xxl,
            border: Border.all(
              color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withOpacity(0.08),
            ),
            boxShadow: AppShadows.cardShadow(isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(CupertinoIcons.clock_fill, size: 20, color: AppColors.accentOrange),
                  const SizedBox(width: 10),
                  Text(
                    "Operating Hours",
                    style: AppTypography.heading.copyWith(
                      color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildScheduleRow("Monday – Thursday", "2:00 PM – 10:00 PM", "Afternoon & Evening Sessions", false, theme, isDark),
              const SizedBox(height: 12),
              _buildScheduleRow("Friday – Sunday", "24 Hours (Non-Stop)", "Round-the-clock rallies & caffeine", true, theme, isDark),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Address Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: AppRadii.xxl,
            border: Border.all(
              color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withOpacity(0.08),
            ),
            boxShadow: AppShadows.cardShadow(isDark),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(CupertinoIcons.location_solid, size: 20, color: isDark ? AppColors.accentOrange : AppColors.deepBlue),
                  const SizedBox(width: 10),
                  Text(
                    "Exact Address",
                    style: AppTypography.heading.copyWith(
                      color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(store.venue, style: AppTypography.headingSmall.copyWith(color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue)),
              const SizedBox(height: 4),
              Text("${store.address}, ${store.province}", style: AppTypography.body.copyWith(color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay)),
              const SizedBox(height: 10),
              Text("Landmark: Beside major Kawit/Noveleta transit corridors with direct Cavitex access.", style: AppTypography.receipt.copyWith(color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleRow(String dayTitle, String hours, String note, bool isHighlight, ThemeController theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.accentOrange.withOpacity(isDark ? 0.18 : 0.08)
            : (isDark ? const Color(0x22FFFFFF) : AppColors.deepBlue.withOpacity(0.04)),
        borderRadius: AppRadii.xl,
        border: Border.all(
          color: isHighlight ? AppColors.accentOrange.withOpacity(0.4) : (isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withOpacity(0.08)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dayTitle, style: AppTypography.headingSmall.copyWith(color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue)),
              Text(hours, style: AppTypography.scoreboard.copyWith(color: isHighlight ? AppColors.accentOrange : (isDark ? AppColors.textPrimaryNight : AppColors.deepBlue))),
            ],
          ),
          const SizedBox(height: 4),
          Text(note, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay)),
        ],
      ),
    );
  }

  Widget _buildMapVisualCard(StoreInfo store, ThemeController theme, bool isDark) {
    final cardBg = isDark ? AppColors.surfaceNightL2 : AppColors.surfaceDayL2;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadii.xxl,
        border: Border.all(color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withOpacity(0.08)),
        boxShadow: AppShadows.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.map_fill, size: 20, color: AppColors.accentOrange),
              const SizedBox(width: 10),
              Text("Courtside Map Locator", style: AppTypography.heading.copyWith(color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue)),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0A141F) : AppColors.softSand,
              borderRadius: AppRadii.xl,
              border: Border.all(color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withOpacity(0.1)),
            ),
            child: Stack(
              children: [
                const Positioned(top: 20, left: 20, child: ArcoCourtLine(width: 120)),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: AppRadii.lg,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.circle_grid_hex_fill, size: 14, color: AppColors.pureWhite),
                            SizedBox(width: 6),
                            Text("ARCOFFEE", style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(CupertinoIcons.location_solid, size: 28, color: AppColors.accentOrange),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ArcoButton(
            text: "Get Directions (Waze / Google Maps)",
            icon: CupertinoIcons.arrow_turn_up_right,
            onPressed: () {},
            variant: ArcoButtonVariant.primary,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(StoreInfo store, ThemeController theme, bool isDark) {
    final cardBg = isDark ? AppColors.surfaceNightL2 : AppColors.surfaceDayL2;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadii.xxl,
        border: Border.all(color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withOpacity(0.08)),
        boxShadow: AppShadows.cardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.sparkles, size: 20, color: AppColors.accentOrange),
              const SizedBox(width: 10),
              Text("Facility Highlights & Amenities", style: AppTypography.heading.copyWith(color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue)),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: store.courtAmenities.map((amenity) {
              return ArcoScoreboardMetadata(label: "AMENITY", value: amenity);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
