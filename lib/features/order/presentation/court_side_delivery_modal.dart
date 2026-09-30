import 'package:flutter/cupertino.dart';
import '../../../core/design/app_colors.dart';
import '../../../core/design/app_typography.dart';
import '../../../data/services/order_tray_service.dart';
import '../../../shared/components/arco_glass_surface.dart';
import '../../../theme/theme_controller.dart';
import 'widgets/empty_tray_view.dart';

/// Apple HIG Interactive "Court-Side Delivery" Modal Sheet.
/// Empowers players standing at the court to request delivery directly to their court number,
/// inspect their tray, adjust quantities, and dispatch orders to the court barista.
class CourtSideDeliveryModal extends StatefulWidget {
  final VoidCallback? onExploreMenu;

  const CourtSideDeliveryModal({
    super.key,
    this.onExploreMenu,
  });

  static Future<void> show(BuildContext context, {VoidCallback? onExploreMenu}) {
    return showCupertinoModalPopup<void>(
      context: context,
      barrierColor: const Color(0x9907111D),
      builder: (ctx) => CourtSideDeliveryModal(onExploreMenu: onExploreMenu),
    );
  }

  @override
  State<CourtSideDeliveryModal> createState() => _CourtSideDeliveryModalState();
}

class _CourtSideDeliveryModalState extends State<CourtSideDeliveryModal> {
  late final TextEditingController _courtInputController;
  late final TextEditingController _noteController;
  bool _isDispatched = false;

  final List<String> _quickCourts = ['1', '2', '3', '4', '5', '6', '7', '8'];

  @override
  void initState() {
    super.initState();
    final currentCourt = OrderTrayService.instance.courtNumber.isNotEmpty
        ? OrderTrayService.instance.courtNumber
        : '1';
    _courtInputController = TextEditingController(text: currentCourt);
    _noteController = TextEditingController(text: OrderTrayService.instance.playerNote);
  }

  @override
  void dispose() {
    _courtInputController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onConfirmOrder() async {
    if (_isDispatched) return;
    setState(() => _isDispatched = true);

    // Save final court delivery notes
    OrderTrayService.instance.setCourtNumber(_courtInputController.text.trim());
    OrderTrayService.instance.setPlayerNote(_noteController.text.trim());

    await Future.delayed(const Duration(milliseconds: 1400));
    if (mounted) {
      OrderTrayService.instance.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;
    final tray = OrderTrayService.instance;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 780),
        child: ArcoGlassSurface(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          borderRadius: 24,
          blurSigma: 24.0,
          backgroundColor: isDark
              ? const Color(0xF20B1F33)
              : AppColors.warmCream.withValues(alpha: 0.98),
          borderColor: isDark
              ? const Color(0x408FA2B5)
              : AppColors.deepBlue.withValues(alpha: 0.12),
          child: AnimatedBuilder(
            animation: tray,
            builder: (context, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _buildHeader(theme, isDark),

                  // Scrollable Body
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(22.0),
                      child: tray.isEmpty
                          ? EmptyTrayView(
                              onExploreMenu: () {
                                Navigator.of(context).pop();
                                widget.onExploreMenu?.call();
                              },
                            )
                          : _buildActiveOrderContent(theme, isDark, tray),
                    ),
                  ),

                  // Bottom Action Bar (when tray has items)
                  if (tray.isNotEmpty) _buildBottomActionBar(theme, isDark, tray),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeController theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0x33FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.04),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0x22FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.08),
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "COURT-SIDE DELIVERY",
                style: AppTypography.scoreboard.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.accentOrange,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "The Pickleground PH • Arena Bar",
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryText,
                ),
              ),
            ],
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 32,
            borderRadius: BorderRadius.circular(16),
            color: isDark ? const Color(0x33FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.08),
            onPressed: () => Navigator.of(context).pop(),
            child: Icon(
              CupertinoIcons.xmark,
              size: 16,
              color: theme.primaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderContent(ThemeController theme, bool isDark, OrderTrayService tray) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Order Mode Selector: Deliver to Court vs Pick Up at Bar
        _buildSectionHeader("1. FULFILLMENT METHOD", CupertinoIcons.location_north_fill),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0x22FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: CupertinoSlidingSegmentedControl<bool>(
            backgroundColor: CupertinoColors.transparent,
            thumbColor: isDark ? const Color(0xFF18354F) : AppColors.pureWhite,
            groupValue: tray.isCourtDelivery,
            onValueChanged: (val) {
              if (val != null) tray.setCourtDelivery(val);
            },
            children: {
              true: _buildSegmentOption("Deliver to Court\n(Direct to Game)", tray.isCourtDelivery, isDark),
              false: _buildSegmentOption("Pickup at Bar\n(Counter Collect)", !tray.isCourtDelivery, isDark),
            },
          ),
        ),
        const SizedBox(height: 20),

        // 2. Court Number Picker (When Deliver to Court is active)
        if (tray.isCourtDelivery) ...[
          _buildSectionHeader("2. SELECT YOUR COURT NUMBER", CupertinoIcons.sportscourt),
          const SizedBox(height: 10),

          // Quick selection chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickCourts.map((cNum) {
              final isSelected = _courtInputController.text.trim() == cNum;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _courtInputController.text = cNum;
                    tray.setCourtNumber(cNum);
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  width: 52,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accentOrange
                        : (isDark ? const Color(0x22FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.05)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accentOrange
                          : (isDark ? const Color(0x33FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.1)),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "C$cNum",
                      style: TextStyle(
                        fontFamily: AppTypography.monoFont,
                        fontFamilyFallback: AppTypography.monoFontFallback,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: isSelected ? AppColors.pureWhite : theme.primaryText,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Custom Input field for custom court/area
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0x18FFFFFF) : AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? const Color(0x33FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.12),
                      width: 1.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.centerLeft,
                  child: CupertinoTextField(
                    controller: _courtInputController,
                    placeholder: "Enter Court # or Area (e.g., Court 3 Baseline)",
                    placeholderStyle: TextStyle(
                      fontFamily: AppTypography.bodyFont,
                      fontSize: 13,
                      color: theme.tertiaryText,
                    ),
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontFamilyFallback: AppTypography.monoFontFallback,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: theme.primaryText,
                    ),
                    decoration: const BoxDecoration(),
                    onChanged: (val) => tray.setCourtNumber(val),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Court runners deliver directly to your baseline between rallies.",
            style: AppTypography.receipt.copyWith(
              fontSize: 11,
              color: isDark ? AppColors.textTertiaryNight : AppColors.textTertiaryDay,
            ),
          ),
          const SizedBox(height: 22),
        ],

        // 3. Tray Items Summary
        _buildSectionHeader("3. CURRENT TRAY ITEMS (${tray.itemCount})", CupertinoIcons.bag),
        const SizedBox(height: 10),
        Column(
          children: tray.items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0x18FFFFFF) : AppColors.pureWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0x22FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.08),
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  // Drink Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: item.menuItem.accentColor.withValues(alpha: 0.15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.menuItem.imageAsset != null
                          ? Image.asset(item.menuItem.imageAsset!, fit: BoxFit.cover)
                          : Icon(item.menuItem.category.icon, size: 22, color: item.menuItem.accentColor),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Drink Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.menuItem.name,
                          style: TextStyle(
                            fontFamily: AppTypography.displayFont,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: theme.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.customizationSummary,
                          style: TextStyle(
                            fontFamily: AppTypography.bodyFont,
                            fontSize: 11,
                            color: theme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quantity Controls
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 28,
                        onPressed: () => tray.updateQuantity(item.id, -1),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? const Color(0x33FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.08),
                          ),
                          child: const Icon(CupertinoIcons.minus, size: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "${item.quantity}",
                          style: TextStyle(
                            fontFamily: AppTypography.monoFont,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: theme.primaryText,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minSize: 28,
                        onPressed: () => tray.updateQuantity(item.id, 1),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? const Color(0x33FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.08),
                          ),
                          child: const Icon(CupertinoIcons.plus, size: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),

                  // Item Price
                  Text(
                    "₱${item.totalPrice.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontFamily: AppTypography.monoFont,
                      fontFamilyFallback: AppTypography.monoFontFallback,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppColors.accentOrange,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(ThemeController theme, bool isDark, OrderTrayService tray) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F243A) : AppColors.surfaceDayL3,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withValues(alpha: 0.08),
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tray.isCourtDelivery
                    ? "DELIVER TO: COURT #${_courtInputController.text.trim()}"
                    : "PICKUP: ARENA BAR COUNTER",
                style: AppTypography.scoreboard.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.accentOrange,
                ),
              ),
              Text(
                "TOTAL: ₱${tray.totalAmount.toStringAsFixed(0)}",
                style: TextStyle(
                  fontFamily: AppTypography.monoFont,
                  fontFamilyFallback: AppTypography.monoFontFallback,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: theme.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Confirm Button
          GestureDetector(
            onTap: _onConfirmOrder,
            child: AnimatedScale(
              scale: _isDispatched ? 0.98 : 1.0,
              duration: const Duration(milliseconds: 140),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 50,
                decoration: BoxDecoration(
                  color: _isDispatched ? const Color(0xFF34C759) : AppColors.accentOrange,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: theme.glowingOrangeShadow,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isDispatched ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.paperplane_fill,
                        size: 18,
                        color: AppColors.pureWhite,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _isDispatched
                            ? "Dispatched to Court #${_courtInputController.text.trim()} Runner!"
                            : "Confirm Court-Side Delivery • ₱${tray.totalAmount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.pureWhite,
                          letterSpacing: -0.2,
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
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.accentOrange),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppTypography.eyebrow.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            color: AppColors.accentOrange,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentOption(String text, bool isSelected, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          color: isSelected
              ? AppColors.accentOrange
              : (isDark ? const Color(0xFF8FA2B5) : AppColors.textPrimaryDay),
          height: 1.25,
        ),
      ),
    );
  }
}
