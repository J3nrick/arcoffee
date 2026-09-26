import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/store_info.dart';
import '../../../data/repositories/store_repository.dart';
import '../../../shared/widgets/badge_pill.dart';
import '../../../shared/widgets/frosted_glass_container.dart';
import '../../../shared/widgets/status_pill.dart';

/// Location & Operating Hours View showcasing The Pickleground PH venue,
/// operating schedules (Mon-Thu 2PM-10PM, Fri-Sun 24 Hours), and court amenities.
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
    final horizontalPad = Responsive.horizontalPadding(context);
    final isDesktop = Responsive.isDesktop(context);

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
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BadgePill(
                        label: "LOCATION & SCHEDULE",
                        icon: CupertinoIcons.location_fill,
                        backgroundColor: Color(0xFFF3ECE0),
                        textColor: AppColors.primaryBlue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Visit Arcoffee",
                        style: AppTypography.title1.copyWith(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Located directly at The Pickleground PH in Kawit / Noveleta, Cavite.",
                        style: AppTypography.callout.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusPill(
                  text: _isOpenNow ? "COURT & BAR OPEN" : "CLOSED NOW",
                  isOpen: _isOpenNow,
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Responsive Layout: Hours & Details on Left, Interactive Map Card on Right
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildHoursAndDetails(store)),
                  const SizedBox(width: 24),
                  Expanded(flex: 5, child: _buildMapVisualCard(store)),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHoursAndDetails(store),
                  const SizedBox(height: 24),
                  _buildMapVisualCard(store),
                ],
              ),

            const SizedBox(height: 32),

            // Amenities Grid
            _buildAmenitiesSection(store),
          ],
        ),
      ),
    );
  }

  Widget _buildHoursAndDetails(StoreInfo store) {
    return Column(
      children: [
        // Hours Card
        FrostedGlassContainer(
          borderRadius: 20,
          backgroundColor: AppColors.pureWhite.withOpacity(0.92),
          borderColor: AppColors.borderLight,
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.clock_fill,
                    size: 20,
                    color: AppColors.accentOrange,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Operating Hours",
                    style: AppTypography.title3.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Weekdays
              _buildScheduleRow(
                dayTitle: "Monday – Thursday",
                hours: "2:00 PM – 10:00 PM",
                note: "Afternoon & Evening Court Sessions",
                isHighlight: false,
              ),
              const SizedBox(height: 12),

              // Weekend 24 Hours
              _buildScheduleRow(
                dayTitle: "Friday – Sunday",
                hours: "24 Hours (Non-Stop)",
                note: "Round-the-clock rallies, matches & caffeine",
                isHighlight: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Exact Address Card
        FrostedGlassContainer(
          borderRadius: 20,
          backgroundColor: AppColors.pureWhite.withOpacity(0.92),
          borderColor: AppColors.borderLight,
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.placemark_fill,
                    size: 20,
                    color: AppColors.primaryBlue,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Exact Address",
                    style: AppTypography.title3.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                store.venue,
                style: AppTypography.headline.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${store.address}, ${store.province}",
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Landmark: Beside major Kawit/Noveleta transit corridors with direct access to Cavitex.",
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textTertiary,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.accentOrange.withOpacity(0.08)
            : AppColors.primaryBlue.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlight
              ? AppColors.accentOrange.withOpacity(0.3)
              : AppColors.borderLight,
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
                style: AppTypography.headline.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
              Text(
                hours,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isHighlight ? AppColors.accentOrange : AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            note,
            style: AppTypography.caption1.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapVisualCard(StoreInfo store) {
    return FrostedGlassContainer(
      borderRadius: 20,
      backgroundColor: AppColors.pureWhite.withOpacity(0.92),
      borderColor: AppColors.borderLight,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    CupertinoIcons.map_fill,
                    size: 20,
                    color: AppColors.sodaBlue,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Courtside Map Locator",
                    style: AppTypography.title3.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const BadgePill(
                label: "GPS READY",
                backgroundColor: Color(0xFFE8F5E9),
                textColor: Color(0xFF2E7D32),
                isSmall: true,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stylized Apple-like Vector Map Canvas
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E9EE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.borderLight,
                width: 0.8,
              ),
            ),
            child: Stack(
              children: [
                // Simulated road lines
                Positioned(
                  left: 0,
                  right: 0,
                  top: 95,
                  height: 18,
                  child: Container(
                    color: AppColors.pureWhite,
                  ),
                ),
                Positioned(
                  left: 140,
                  top: 0,
                  bottom: 0,
                  width: 18,
                  child: Container(
                    color: AppColors.pureWhite,
                  ),
                ),
                // Court Area
                Positioned(
                  left: 170,
                  top: 25,
                  right: 30,
                  bottom: 125,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.pickleballGreen.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.pickleballGreen,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "PICKLEBALL COURTS",
                      style: AppTypography.caption2.copyWith(
                        color: const Color(0xFF2E7D32),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // Arcoffee Pin
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentOrange.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.circle_grid_hex_fill, size: 12, color: AppColors.pureWhite),
                            SizedBox(width: 4),
                            Text(
                              "ARCOFFEE",
                              style: TextStyle(
                                color: AppColors.pureWhite,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Icon(
                        CupertinoIcons.location_solid,
                        size: 26,
                        color: AppColors.accentOrange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Action Button
          CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 12),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primaryBlue,
            onPressed: () {
              // Open directions
            },
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
                      fontWeight: FontWeight.w600,
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

  Widget _buildAmenitiesSection(StoreInfo store) {
    return FrostedGlassContainer(
      borderRadius: 20,
      backgroundColor: AppColors.pureWhite.withOpacity(0.92),
      borderColor: AppColors.borderLight,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.sparkles,
                size: 20,
                color: AppColors.accentOrange,
              ),
              const SizedBox(width: 10),
              Text(
                "Courtside Facility Highlights & Amenities",
                style: AppTypography.title3.copyWith(
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: store.courtAmenities.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.borderLight,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      size: 14,
                      color: AppColors.statusOpen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amenity,
                      style: AppTypography.footnote.copyWith(
                        color: AppColors.textPrimary,
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
