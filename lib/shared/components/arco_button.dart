import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_radii.dart';
import '../../core/design/app_typography.dart';
import '../../theme/theme_controller.dart';

enum ArcoButtonVariant {
  primary,
  secondary,
  ghost,
}

/// Reusable Brand Action Button with 44pt tap target minimums and calm hover transitions.
class ArcoButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final ArcoButtonVariant variant;
  final bool isFullWidth;

  const ArcoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.variant = ArcoButtonVariant.primary,
    this.isFullWidth = false,
  });

  @override
  State<ArcoButton> createState() => _ArcoButtonState();
}

class _ArcoButtonState extends State<ArcoButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    Color bg;
    Color fg;
    Border? border;

    switch (widget.variant) {
      case ArcoButtonVariant.primary:
        bg = _isHovered
            ? AppColors.accentOrange.withValues(alpha: 0.92)
            : AppColors.accentOrange;
        fg = AppColors.pureWhite;
        break;
      case ArcoButtonVariant.secondary:
        bg = _isHovered
            ? (isDark ? const Color(0xFF1B3045) : AppColors.deepBlue.withValues(alpha: 0.12))
            : (isDark ? const Color(0xFF122334) : AppColors.deepBlue.withValues(alpha: 0.06));
        fg = isDark ? AppColors.textPrimaryNight : AppColors.deepBlue;
        border = Border.all(
          color: isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withValues(alpha: 0.1),
        );
        break;
      case ArcoButtonVariant.ghost:
        bg = _isHovered
            ? (isDark ? const Color(0x22FFFFFF) : AppColors.deepBlue.withValues(alpha: 0.05))
            : CupertinoColors.transparent;
        fg = isDark ? AppColors.accentOrange : AppColors.deepBlue;
        break;
    }

    Widget content = AnimatedContainer(
      duration: AppMotion.fast,
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minHeight: 44.0, minWidth: 44.0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.lg,
        border: border,
        boxShadow: (widget.variant == ArcoButtonVariant.primary && _isHovered)
            ? [
                BoxShadow(
                  color: AppColors.accentOrange.withValues(alpha: 0.38),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, size: 16, color: fg),
            const SizedBox(width: 8),
          ],
          Text(
            widget.text,
            style: TextStyle(
              fontFamily: AppTypography.displayFont,
              fontFamilyFallback: AppTypography.displayFontFallback,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: fg,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0),
          duration: _isPressed
              ? const Duration(milliseconds: 90)
              : const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: content,
        ),
      ),
    );
  }
}
