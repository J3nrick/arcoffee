import 'package:flutter/cupertino.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/menu_item.dart';
import '../../../../shared/widgets/badge_pill.dart';

/// Cupertino Modal Sheet displaying complete drink specifications.
class MenuDetailSheet extends StatelessWidget {
  final MenuItem item;

  const MenuDetailSheet({super.key, required this.item});

  static void show(BuildContext context, MenuItem item) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierColor: AppColors.deepNavy.withValues(alpha: 0.4),
      builder: (ctx) => MenuDetailSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.creamBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.borderLight,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepNavy.withValues(alpha: 0.2),
                blurRadius: 36,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Visual Top Banner
              Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      item.accentColor.withValues(alpha: 0.35),
                      item.accentColor.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Close button
                    Positioned(
                      top: 14,
                      right: 14,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(32, 32),
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.deepNavy.withValues(alpha: 0.12),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          size: 16,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: item.accentColor.withValues(alpha: 0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              item.category.icon,
                              color: item.accentColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 8),
                          BadgePill(
                            label: item.category.displayName.toUpperCase(),
                            backgroundColor: item.accentColor.withValues(alpha: 0.18),
                            textColor: item.accentColor,
                            isSmall: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content Body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: AppTypography.title2.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item.displayPrice,
                          style: AppTypography.title2.copyWith(
                            color: AppColors.accentOrange,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: AppTypography.body.copyWith(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Metadata attributes
                    _buildAttributeRow(
                      icon: CupertinoIcons.sparkles,
                      label: "Serving Size",
                      value: item.size,
                    ),
                    const SizedBox(height: 8),
                    _buildAttributeRow(
                      icon: CupertinoIcons.bolt_fill,
                      label: "Energy Profile",
                      value: item.caffeineNote,
                    ),
                    const SizedBox(height: 8),
                    _buildAttributeRow(
                      icon: CupertinoIcons.sportscourt,
                      label: "Courtside Recommendation",
                      value: item.isCourtFavorite
                          ? "Perfect pre/post pickleball rally fuel"
                          : "Great for leisurely courtside spectator chilling",
                    ),

                    if (item.tags.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: item.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "#$tag",
                              style: AppTypography.caption1.copyWith(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Primary Action
                    CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(14),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Center(
                        child: Text(
                          "Done",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.pureWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttributeRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accentOrange),
        const SizedBox(width: 10),
        Text(
          "$label: ",
          style: AppTypography.footnote.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.footnote.copyWith(
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
