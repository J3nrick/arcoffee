import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/state/view_state.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/gallery_item.dart';
import '../../../data/repositories/gallery_repository.dart';
import '../../../shared/widgets/apple_alert.dart';
import '../../../shared/widgets/badge_pill.dart';
import '../../../theme/theme_controller.dart';
import 'controllers/gallery_controller.dart';

/// Represents a sticker placed on the Community Board by user dragging.
class PlacedSticker {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  Offset position;
  final double rotation;

  PlacedSticker({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.position,
    required this.rotation,
  });
}

/// Interactive Digital Community Board with physical polaroids, authentic photo tape,
/// and draggable digital stickers (Pickleball badges, "It's always been ours.").
class GalleryView extends StatefulWidget {
  final GalleryRepository repository;

  const GalleryView({super.key, required this.repository});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  late final GalleryViewController _controller;

  // Active placed stickers on the community corkboard
  final List<PlacedSticker> _placedStickers = [
    PlacedSticker(
      id: 'default_s1',
      label: "It's always been ours.",
      icon: CupertinoIcons.sparkles,
      color: AppColors.accentOrange,
      position: const Offset(40, 60),
      rotation: -0.06,
    ),
    PlacedSticker(
      id: 'default_s2',
      label: "DINK RESPONSIBLY 🏓",
      icon: CupertinoIcons.sportscourt_fill,
      color: AppColors.matchaGreen,
      position: const Offset(280, 110),
      rotation: 0.05,
    ),
    PlacedSticker(
      id: 'default_s3',
      label: "KAWIT • NOVELETA 24/7",
      icon: CupertinoIcons.moon_stars_fill,
      color: AppColors.sodaBlue,
      position: const Offset(620, 75),
      rotation: -0.03,
    ),
  ];

  final List<Map<String, dynamic>> _stickerLibrary = [
    {
      'label': "It's always been ours.",
      'icon': CupertinoIcons.sparkles,
      'color': AppColors.accentOrange,
    },
    {
      'label': "DINK RESPONSIBLY",
      'icon': CupertinoIcons.sportscourt_fill,
      'color': AppColors.matchaGreen,
    },
    {
      'label': "24H MIDNIGHT RUN",
      'icon': CupertinoIcons.moon_stars_fill,
      'color': Color(0xFF7C4DFF),
    },
    {
      'label': "100% CAVITE FUEL",
      'icon': CupertinoIcons.bolt_fill,
      'color': Color(0xFFFF6D00),
    },
    {
      'label': "MATCH POINT WINNER",
      'icon': CupertinoIcons.flag_fill,
      'color': AppColors.sodaBlue,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = GalleryViewController(repository: widget.repository);
    _controller.loadGallery();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    if (_controller.state.isError) {
      AppleAlert.showError(
        context: context,
        title: 'Board Unavailable',
        message: _controller.state.errorMessage ?? 'Unable to connect to community feed.',
        onRetry: () => _controller.retry(),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPad = Responsive.horizontalPadding(context);
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final state = _controller.state;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BadgePill(
                        label: "COMMUNITY BOARD & STICKER WALL",
                        icon: CupertinoIcons.person_3_fill,
                        backgroundColor: Color(0xFFE5F0F8),
                        textColor: AppColors.sodaBlue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Courtside Polaroids & Culture",
                        style: AppTypography.title1.copyWith(
                          color: theme.primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Drag custom Arcoffee stickers onto the photos below! Real rallies from The Pickleground PH.",
                        style: AppTypography.callout.copyWith(
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Draggable Sticker Dock
            _buildStickerDock(isDark),
            const SizedBox(height: 28),

            // Drag Target Canvas wrapping the polaroids
            DragTarget<Map<String, dynamic>>(
              onAcceptWithDetails: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localPos = box.globalToLocal(details.offset);
                final randomAngle = (math.Random().nextDouble() * 0.16) - 0.08;

                setState(() {
                  _placedStickers.add(
                    PlacedSticker(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      label: details.data['label'],
                      icon: details.data['icon'],
                      color: details.data['color'],
                      position: localPos,
                      rotation: randomAngle,
                    ),
                  );
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildStateContent(state, isDark),

                    // Overlay Placed Stickers
                    ..._placedStickers.map((sticker) {
                      return Positioned(
                        left: sticker.position.dx.clamp(0.0, 960.0),
                        top: sticker.position.dy.clamp(0.0, 1800.0),
                        child: Transform.rotate(
                          angle: sticker.rotation,
                          child: GestureDetector(
                            onPanUpdate: (drag) {
                              setState(() {
                                sticker.position += drag.delta;
                              });
                            },
                            child: _buildStickerWidget(
                              sticker.label,
                              sticker.icon,
                              sticker.color,
                              isDraggable: true,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickerDock(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101E2C) : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0x338FA2B5) : AppColors.borderLight,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.hand_draw_fill, size: 16, color: AppColors.accentOrange),
              const SizedBox(width: 8),
              Text(
                "STICKER DOCK • DRAG & DROP ONTO PHOTOS",
                style: AppTypography.caption2.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                  color: AppColors.accentOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _stickerLibrary.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Draggable<Map<String, dynamic>>(
                    data: item,
                    feedback: DefaultTextStyle(
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                        fontFamily: '-apple-system',
                      ),
                      child: Transform.scale(
                        scale: 1.1,
                        child: _buildStickerWidget(
                          item['label'],
                          item['icon'],
                          item['color'],
                        ),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.35,
                      child: _buildStickerWidget(
                        item['label'],
                        item['icon'],
                        item['color'],
                      ),
                    ),
                    child: _buildStickerWidget(
                      item['label'],
                      item['icon'],
                      item['color'],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickerWidget(
    String label,
    IconData icon,
    Color color, {
    bool isDraggable = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.pureWhite, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.pureWhite),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.pureWhite,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateContent(ViewState<List<GalleryItem>> state, bool isDark) {
    if (state.isLoading && (state.data == null || state.data!.isEmpty)) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80.0),
          child: Column(
            children: [
              CupertinoActivityIndicator(radius: 18),
              SizedBox(height: 14),
              Text(
                "Pinning community polaroids...",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    final items = state.data ?? [];
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columnCount = 1;
        if (width >= 880) {
          columnCount = 3;
        } else if (width >= 560) {
          columnCount = 2;
        }

        return _buildPolaroidGrid(items, columnCount, isDark);
      },
    );
  }

  Widget _buildPolaroidGrid(List<GalleryItem> items, int columnCount, bool isDark) {
    final List<List<GalleryItem>> columns = List.generate(columnCount, (_) => []);

    for (int i = 0; i < items.length; i++) {
      columns[i % columnCount].add(items[i]);
    }

    final tiltAngles = [-0.015, 0.018, -0.012, 0.02, -0.018, 0.01];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(columnCount, (colIndex) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: colIndex == 0 ? 0 : 10,
              right: colIndex == columnCount - 1 ? 0 : 10,
            ),
            child: Column(
              children: columns[colIndex].asMap().entries.map((entry) {
                final itemIndex = (colIndex * 3) + entry.key;
                final tilt = tiltAngles[itemIndex % tiltAngles.length];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 22.0),
                  child: Transform.rotate(
                    angle: tilt,
                    child: _buildPolaroidCard(entry.value, isDark),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPolaroidCard(GalleryItem item, bool isDark) {
    final isLiked = _controller.isLiked(item.id);

    return RepaintBoundary(
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF132230) : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0x338FA2B5) : const Color(0x180F2537),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? const Color(0x60000000)
                  : AppColors.deepNavy.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Polaroid Photo View
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 170 * item.heightRatio,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      item.primaryColor.withOpacity(0.9),
                      item.secondaryColor.withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Top Category Stamp
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.deepNavy.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.category.toUpperCase(),
                          style: AppTypography.caption2.copyWith(
                            color: AppColors.pureWhite,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Icon(
                        item.icon,
                        size: 46,
                        color: AppColors.pureWhite.withOpacity(0.95),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Polaroid Bottom Margin: Handwritten style notes
            Text(
              item.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: isDark ? const Color(0xFFFAF7F2) : AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF8FA2B5) : AppColors.textSecondary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Footer info with like counter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _controller.toggleLike(item.id),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      children: [
                        AnimatedScale(
                          scale: isLiked ? 1.25 : 1.0,
                          duration: const Duration(milliseconds: 140),
                          child: Icon(
                            isLiked ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                            size: 17,
                            color: isLiked ? AppColors.accentOrange : const Color(0xFF8FA2B5),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isLiked
                              ? "${int.parse(item.likesCount) + 1}"
                              : item.likesCount,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isLiked ? AppColors.accentOrange : const Color(0xFF8FA2B5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "Kawit • ${item.timestamp}",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF8FA2B5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
