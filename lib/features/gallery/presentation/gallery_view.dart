import 'package:flutter/cupertino.dart';
import '../../../core/design/app_breakpoints.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_radii.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/models/gallery_item.dart';
import '../../../data/repositories/gallery_repository.dart';
import '../../../shared/components/arco_sticker.dart';
import '../../../theme/theme_controller.dart';

/// "The Arcoffee Wall" Community Section: Curated collage of photography,
/// stickers, court atmosphere, and social coffee culture.
class GalleryView extends StatefulWidget {
  final GalleryRepository repository;

  const GalleryView({super.key, required this.repository});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  List<GalleryItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGalleryData();
  }

  Future<void> _loadGalleryData() async {
    final items = await widget.repository.getGalleryItems();
    if (!mounted) return;
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final isMobile = AppBreakpoints.isMobile(context);
    final isTablet = AppBreakpoints.isTablet(context);
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
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 36),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppBreakpoints.desktopMax),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ArcoSticker(text: "THE ARCOFFEE WALL", rotation: -0.02),
                    const SizedBox(height: 8),
                    Text(
                      "Community & Courtside Stories",
                      style: AppTypography.display.copyWith(
                        color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                        fontSize: isMobile ? 26 : 36,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Good coffee, great rallies, and unforgettable midnight sessions at The Pickleground PH.",
                      style: AppTypography.bodyLarge.copyWith(
                        color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Wall Grid Collage
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
              ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final rotation = (index % 2 == 0) ? 0.015 : -0.015;

                return Transform.rotate(
                  angle: isMobile ? 0.0 : rotation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceNightL2 : AppColors.surfaceDayL2,
                      borderRadius: AppRadii.xl,
                      border: Border.all(
                        color: isDark ? const Color(0x228FA2B5) : AppColors.deepBlue.withOpacity(0.08),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Container
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: item.primaryColor.withOpacity(0.15),
                              borderRadius: AppRadii.lg,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.photo,
                                  size: 32,
                                  color: item.primaryColor,
                                ),
                                const SizedBox(height: 8),
                                ArcoSticker(text: item.category, rotation: 0.0),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Title & Subtitle/Timestamp
                        Text(
                          item.title,
                          style: AppTypography.headingSmall.copyWith(
                            color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.subtitle,
                              style: AppTypography.receipt.copyWith(
                                color: AppColors.accentOrange,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              item.timestamp,
                              style: AppTypography.receipt.copyWith(
                                color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
