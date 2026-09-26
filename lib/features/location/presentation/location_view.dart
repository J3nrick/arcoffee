import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/store_info.dart';
import '../../../data/repositories/store_repository.dart';
import '../../../shared/widgets/frosted_glass_container.dart';
import '../../../theme/theme_controller.dart';

/// Clean, high-contrast Location & Operating Hours View.
/// Features true Liquid Glass cards, bold Apple typography, and vibrant Arcoffee Orange accents.
class LocationView extends StatefulWidget {
  final StoreRepository repository;

  const LocationView({super.key, required this.repository});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  StoreInfo? _storeInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStoreData();
  }

  Future<void> _loadStoreData() async {
    final info = await widget.repository.getStoreInfo();
    if (!mounted) return;
    setState(() {
      _storeInfo = info;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);
    final isDesktop = Responsive.isDesktop(context);
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
        constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bold Clean Header (No redundant badges)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Visit Arcoffee",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "The Pickleground PH • Kawit / Noveleta, Cavite",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accentOrange,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Main Responsive Content Grid
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

            // Amenities Section
            _buildAmenitiesSection(store, theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursAndDetails(StoreInfo store, ThemeController theme, bool isDark) {
    return Column(
      children: [
        // Operating Hours Liquid Glass Card
        FrostedGlassContainer(
          borderRadius: 24,
          blurSigma: 20.0,
          backgroundColor: isDark
              ? const Color(0xCC0E1A26)
              : AppColors.pureWhite.withOpacity(0.85),
          borderColor: isDark
              ? const Color(0x338FA2B5)
              : AppColors.pureWhite.withOpacity(0.6),
          shadow: BoxShadow(
            color: isDark ? const Color(0x66000000) : AppColors.primaryBlue.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.clock_fill,
                    size: 22,
                    color: AppColors.accentOrange,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Operating Hours",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Weekdays (Mon-Thu 2PM-10PM)
              _buildScheduleRow(
                dayTitle: "Monday – Thursday",
                hours: "2:00 PM – 10:00 PM",
                note: "Afternoon & Evening Court Sessions",
                isHighlight: false,
                theme: theme,
                isDark: isDark,
              ),
              const SizedBox(height: 12),

              // Weekend 24 Hours (Fri-Sun)
              _buildScheduleRow(
                dayTitle: "Friday – Sunday",
                hours: "24 Hours (Non-Stop)",
                note: "Round-the-clock rallies, matches & caffeine",
                isHighlight: true,
                theme: theme,
                isDark: isDark,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Exact Address Liquid Glass Card
        FrostedGlassContainer(
          borderRadius: 24,
          blurSigma: 20.0,
          backgroundColor: isDark
              ? const Color(0xCC0E1A26)
              : AppColors.pureWhite.withOpacity(0.85),
          borderColor: isDark
              ? const Color(0x338FA2B5)
              : AppColors.pureWhite.withOpacity(0.6),
          shadow: BoxShadow(
            color: isDark ? const Color(0x66000000) : AppColors.primaryBlue.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    size: 22,
                    color: isDark ? AppColors.accentOrange : AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Exact Address",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                store.venue,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${store.address}, ${store.province}",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: theme.secondaryText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Landmark: Beside major Kawit/Noveleta transit corridors with direct Cavitex access.",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: theme.tertiaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleRow({
    required String dayTitle,
    required String hours,
    required String note,
    required bool isHighlight,
    required ThemeController theme,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.accentOrange.withOpacity(isDark ? 0.18 : 0.08)
            : (isDark ? const Color(0x22FFFFFF) : AppColors.primaryBlue.withOpacity(0.04)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlight
              ? AppColors.accentOrange.withOpacity(0.4)
              : theme.borderLight,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                ),
              ),
              Text(
                hours,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isHighlight ? AppColors.accentOrange : theme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            note,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: theme.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapVisualCard(StoreInfo store, ThemeController theme, bool isDark) {
    return FrostedGlassContainer(
      borderRadius: 24,
      blurSigma: 20.0,
      backgroundColor: isDark
          ? const Color(0xCC0E1A26)
          : AppColors.pureWhite.withOpacity(0.85),
      borderColor: isDark
          ? const Color(0x338FA2B5)
          : AppColors.pureWhite.withOpacity(0.6),
      shadow: BoxShadow(
        color: isDark ? const Color(0x66000000) : AppColors.primaryBlue.withOpacity(0.06),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.map_fill,
                size: 22,
                color: AppColors.sodaBlue,
              ),
              const SizedBox(width: 10),
              Text(
                "Courtside Map Locator",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Vector Map Representation
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0A141F) : const Color(0xFFE8ECEF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: theme.borderLight,
                width: 1.0,
              ),
            ),
            child: Stack(
              children: [
                // Simulated roads
                Positioned(
                  left: 0,
                  right: 0,
                  top: 100,
                  height: 20,
                  child: Container(
                    color: isDark ? const Color(0xFF142434) : AppColors.pureWhite,
                  ),
                ),
                Positioned(
                  left: 150,
                  top: 0,
                  bottom: 0,
                  width: 20,
                  child: Container(
                    color: isDark ? const Color(0xFF142434) : AppColors.pureWhite,
                  ),
                ),
                // Arcoffee Location Pin
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentOrange.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.circle_grid_hex_fill, size: 14, color: AppColors.pureWhite),
                            SizedBox(width: 6),
                            Text(
                              "ARCOFFEE",
                              style: TextStyle(
                                color: AppColors.pureWhite,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Icon(
                        CupertinoIcons.location_solid,
                        size: 28,
                        color: AppColors.accentOrange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Get Directions CTA Button
          CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 14),
            borderRadius: BorderRadius.circular(16),
            color: isDark ? AppColors.accentOrange : AppColors.primaryBlue,
            onPressed: () {},
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.arrow_turn_up_right, size: 16, color: AppColors.pureWhite),
                  SizedBox(width: 8),
                  Text(
                    "Get Directions via Waze / Google Maps",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.pureWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(StoreInfo store, ThemeController theme, bool isDark) {
    return FrostedGlassContainer(
      borderRadius: 24,
      blurSigma: 20.0,
      backgroundColor: isDark
          ? const Color(0xCC0E1A26)
          : AppColors.pureWhite.withOpacity(0.85),
      borderColor: isDark
          ? const Color(0x338FA2B5)
          : AppColors.pureWhite.withOpacity(0.6),
      shadow: BoxShadow(
        color: isDark ? const Color(0x66000000) : AppColors.primaryBlue.withOpacity(0.06),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.sparkles,
                size: 22,
                color: AppColors.accentOrange,
              ),
              const SizedBox(width: 10),
              Text(
                "Courtside Facility Highlights & Amenities",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryText,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: store.courtAmenities.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0x22FFFFFF)
                      : AppColors.primaryBlue.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: theme.borderLight,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      size: 15,
                      color: AppColors.statusOpen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amenity,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
