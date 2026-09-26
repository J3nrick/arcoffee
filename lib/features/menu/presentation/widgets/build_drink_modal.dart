import 'package:flutter/cupertino.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../data/models/menu_item.dart';
import '../../../../shared/widgets/badge_pill.dart';
import '../../../../shared/widgets/frosted_glass_container.dart';
import '../../../../theme/theme_controller.dart';

/// Apple HIG Interactive "Build Your Drink" configuration modal sheet.
/// Offers real-time customizable ice levels, sweetness, milk upgrades,
/// dynamic price calculation, and tactile "Add to Tray" micro-interactions.
class BuildDrinkModal extends StatefulWidget {
  final MenuItem item;

  const BuildDrinkModal({super.key, required this.item});

  static void show(BuildContext context, MenuItem item) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierColor: const Color(0x66000000),
      builder: (ctx) => BuildDrinkModal(item: item),
    );
  }

  @override
  State<BuildDrinkModal> createState() => _BuildDrinkModalState();
}

class _BuildDrinkModalState extends State<BuildDrinkModal> {
  int _selectedSizeIndex = 0; // 0: 16 oz (+0), 1: 20 oz (+25), 2: Cold Bottle (+35)
  int _selectedIceIndex = 1; // 0: Less, 1: Regular, 2: Extra Chill
  int _selectedSweetnessIndex = 2; // 0: Zero, 1: 50%, 2: 100%

  final Set<String> _selectedAddons = {};
  bool _isAddedToTray = false;

  final Map<String, double> _addonsList = {
    'Extra Espresso Shot': 30.0,
    'Oat Milk Upgrade': 35.0,
    'Haw-Haw Sweet Cold Foam': 40.0,
    'Malt Crunch / Powder Overload': 25.0,
  };

  double get _currentTotalPrice {
    double total = widget.item.price;
    if (_selectedSizeIndex == 1) total += 25.0;
    if (_selectedSizeIndex == 2) total += 35.0;

    for (final addon in _selectedAddons) {
      total += _addonsList[addon] ?? 0.0;
    }
    return total;
  }

  void _onAddToTrayPressed() async {
    if (_isAddedToTray) return;
    setState(() => _isAddedToTray = true);

    await Future.delayed(const Duration(milliseconds: 750));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final item = widget.item;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: FrostedGlassContainer(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
          borderRadius: 26,
          blurSigma: 24.0,
          backgroundColor: isDark
              ? const Color(0xE60F1B28)
              : AppColors.creamBackground.withOpacity(0.92),
          borderColor: isDark ? const Color(0x408FA2B5) : AppColors.borderLight,
          shadow: const BoxShadow(
            color: Color(0x40000000),
            blurRadius: 40,
            offset: Offset(0, 18),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Graphic
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        item.accentColor.withOpacity(isDark ? 0.35 : 0.2),
                        item.accentColor.withOpacity(isDark ? 0.1 : 0.04),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: isDark ? const Color(0x22FFFFFF) : AppColors.borderLight,
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: item.accentColor.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              item.category.icon,
                              color: item.accentColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: AppTypography.title3.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: theme.primaryText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Base Price: ${item.displayPrice} • ${item.size}",
                                style: AppTypography.footnote.copyWith(
                                  color: theme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 32,
                        borderRadius: BorderRadius.circular(16),
                        color: isDark ? const Color(0x33FFFFFF) : AppColors.deepNavy.withOpacity(0.1),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Icon(
                          CupertinoIcons.xmark,
                          size: 16,
                          color: theme.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                // Customization Body
                Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Cup Size Selection
                      _buildSectionTitle("1. CHOOSE CUP SIZE", CupertinoIcons.circle_grid_hex),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0x22FFFFFF) : AppColors.primaryBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: CupertinoSlidingSegmentedControl<int>(
                          backgroundColor: CupertinoColors.transparent,
                          thumbColor: isDark ? const Color(0xFF1E3347) : AppColors.pureWhite,
                          groupValue: _selectedSizeIndex,
                          onValueChanged: (val) {
                            if (val != null) setState(() => _selectedSizeIndex = val);
                          },
                          children: {
                            0: _buildSegmentText("Regular 16oz\nStandard", _selectedSizeIndex == 0, isDark),
                            1: _buildSegmentText("Grande 20oz\n+₱25", _selectedSizeIndex == 1, isDark),
                            2: _buildSegmentText("Cold Bottle\n+₱35", _selectedSizeIndex == 2, isDark),
                          },
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Section 2: Ice Level
                      _buildSectionTitle("2. ICE LEVEL", CupertinoIcons.snow),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0x22FFFFFF) : AppColors.primaryBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: CupertinoSlidingSegmentedControl<int>(
                          backgroundColor: CupertinoColors.transparent,
                          thumbColor: isDark ? const Color(0xFF1E3347) : AppColors.pureWhite,
                          groupValue: _selectedIceIndex,
                          onValueChanged: (val) {
                            if (val != null) setState(() => _selectedIceIndex = val);
                          },
                          children: {
                            0: _buildSegmentText("Less (70%)", _selectedIceIndex == 0, isDark),
                            1: _buildSegmentText("Regular (100%)", _selectedIceIndex == 1, isDark),
                            2: _buildSegmentText("Extra Chill", _selectedIceIndex == 2, isDark),
                          },
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Section 3: Sweetness Level
                      _buildSectionTitle("3. SWEETNESS", CupertinoIcons.drop_fill),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0x22FFFFFF) : AppColors.primaryBlue.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: CupertinoSlidingSegmentedControl<int>(
                          backgroundColor: CupertinoColors.transparent,
                          thumbColor: isDark ? const Color(0xFF1E3347) : AppColors.pureWhite,
                          groupValue: _selectedSweetnessIndex,
                          onValueChanged: (val) {
                            if (val != null) setState(() => _selectedSweetnessIndex = val);
                          },
                          children: {
                            0: _buildSegmentText("Unsweetened (0%)", _selectedSweetnessIndex == 0, isDark),
                            1: _buildSegmentText("Half (50%)", _selectedSweetnessIndex == 1, isDark),
                            2: _buildSegmentText("Classic (100%)", _selectedSweetnessIndex == 2, isDark),
                          },
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Section 4: Court Fuel Add-ons
                      _buildSectionTitle("4. COURTSIDE POWER BOOSTERS", CupertinoIcons.bolt_badge_a),
                      const SizedBox(height: 10),
                      Column(
                        children: _addonsList.entries.map((entry) {
                          final isSelected = _selectedAddons.contains(entry.key);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedAddons.remove(entry.key);
                                } else {
                                  _selectedAddons.add(entry.key);
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.accentOrange.withOpacity(isDark ? 0.25 : 0.12)
                                    : (isDark ? const Color(0x18FFFFFF) : AppColors.primaryBlue.withOpacity(0.04)),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accentOrange
                                      : (isDark ? const Color(0x22FFFFFF) : AppColors.borderLight),
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? CupertinoIcons.checkmark_circle_fill
                                            : CupertinoIcons.circle,
                                        size: 18,
                                        color: isSelected ? AppColors.accentOrange : theme.tertiaryText,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        entry.key,
                                        style: AppTypography.footnote.copyWith(
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                          color: isSelected ? theme.primaryText : theme.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "+₱${entry.value.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: isSelected ? AppColors.accentOrange : theme.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Animated "Add to Courtside Tray" Button
                      GestureDetector(
                        onTap: _onAddToTrayPressed,
                        child: AnimatedScale(
                          scale: _isAddedToTray ? 0.96 : 1.0,
                          duration: const Duration(milliseconds: 140),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 52,
                            decoration: BoxDecoration(
                              color: _isAddedToTray ? const Color(0xFF34C759) : AppColors.accentOrange,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: (_isAddedToTray ? const Color(0xFF34C759) : AppColors.accentOrange)
                                      .withOpacity(0.4),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isAddedToTray
                                        ? CupertinoIcons.checkmark_alt
                                        : CupertinoIcons.cart_badge_plus,
                                    size: 20,
                                    color: AppColors.pureWhite,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _isAddedToTray
                                        ? "Added to Courtside Tray!"
                                        : "Add to Tray • ₱${_currentTotalPrice.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.pureWhite,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
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
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.accentOrange),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppTypography.caption2.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.accentOrange,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentText(String text, bool isSelected, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected
              ? (isDark ? AppColors.accentOrange : AppColors.accentOrange)
              : (isDark ? const Color(0xFF8FA2B5) : AppColors.textPrimary),
          height: 1.25,
        ),
      ),
    );
  }
}
