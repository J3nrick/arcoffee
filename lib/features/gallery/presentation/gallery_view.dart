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
  final Set<String> _likedIds = {};
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

  void _toggleLike(String id) async {
    setState(() {
      if (_likedIds.contains(id)) {
        _likedIds.remove(id);
      } else {
        _likedIds.add(id);
      }
    });
    await widget.repository.toggleLike(id);
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
            // Editorial Header Banner
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ArcoSticker(text: "THE ARCOFFEE WALL", rotation: -0.02),
                      const SizedBox(height: 8),
                      Text(
                        "Courtside Community Stories",
                        style: AppTypography.display.copyWith(
                          color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                          fontSize: isMobile ? 26 : 36,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Good coffee, intense rallies, and round-the-clock weekend sessions at The Pickleground PH.",
                        style: AppTypography.bodyLarge.copyWith(
                          color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),

            // Wall Grid Polaroid Collage
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: isMobile ? 0.85 : 0.80,
              ),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isLiked = _likedIds.contains(item.id);
                final rotation = (index % 3 == 0)
                    ? 0.012
                    : (index % 3 == 1)
                        ? -0.015
                        : 0.008;

                return Transform.rotate(
                  angle: isMobile ? 0.0 : rotation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceNightL2 : AppColors.pureWhite,
                      borderRadius: AppRadii.xl,
                      border: Border.all(
                        color: isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withOpacity(0.08),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? const Color(0x40000000) : AppColors.deepBlue.withOpacity(0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Container Frame
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      item.primaryColor.withOpacity(isDark ? 0.3 : 0.15),
                                      item.secondaryColor.withOpacity(isDark ? 0.2 : 0.08),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: AppRadii.lg,
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      item.icon,
                                      size: 40,
                                      color: item.primaryColor,
                                    ),
                                    const SizedBox(height: 10),
                                    ArcoSticker(
                                      text: item.category.toUpperCase(),
                                      rotation: 0.0,
                                    ),
                                  ],
                                ),
                              ),

                              // Top Right Timestamp Tag
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xCC07111D)
                                        : AppColors.pureWhite.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.timestamp,
                                    style: AppTypography.receipt.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textSecondaryNight : AppColors.deepBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Title
                        Text(
                          item.title,
                          style: AppTypography.headingSmall.copyWith(
                            color: isDark ? AppColors.textPrimaryNight : AppColors.deepBlue,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),

                        // Subtitle Story Caption
                        Text(
                          item.subtitle,
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColors.textSecondaryNight : AppColors.textSecondaryDay,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),

                        // Bottom Actions: Like count & Location tag
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "KAWIT, CAVITE",
                              style: AppTypography.receipt.copyWith(
                                color: AppColors.accentOrange,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              minSize: 32,
                              onPressed: () => _toggleLike(item.id),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                    size: 16,
                                    color: isLiked ? AppColors.accentOrange : (isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${(int.tryParse(item.likesCount) ?? 100) + (isLiked ? 1 : 0)}",
                                    style: AppTypography.receipt.copyWith(
                                      color: isLiked ? AppColors.accentOrange : (isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
