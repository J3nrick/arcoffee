import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_radii.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);
    final isDark = theme.isMidnightCourt;

    Color bg;
    Color fg;
    Border? border;

    switch (widget.variant) {
      case ArcoButtonVariant.primary:
        bg = _isHovered ? AppColors.accentOrange.withOpacity(0.9) : AppColors.accentOrange;
        fg = AppColors.pureWhite;
        break;
      case ArcoButtonVariant.secondary:
        bg = _isHovered
            ? (isDark ? const Color(0xFF1B3045) : AppColors.deepBlue.withOpacity(0.12))
            : (isDark ? const Color(0xFF122334) : AppColors.deepBlue.withOpacity(0.06));
        fg = isDark ? AppColors.textPrimaryNight : AppColors.deepBlue;
        border = Border.all(color: isDark ? const Color(0x338FA2B5) : AppColors.deepBlue.withOpacity(0.1));
        break;
      case ArcoButtonVariant.ghost:
        bg = _isHovered
            ? (isDark ? const Color(0x22FFFFFF) : AppColors.deepBlue.withOpacity(0.05))
            : CupertinoColors.transparent;
        fg = isDark ? AppColors.accentOrange : AppColors.deepBlue;
        break;
    }

    Widget content = AnimatedContainer(
      duration: AppMotion.fast,
      constraints: const BoxConstraints(minHeight: 44.0, minWidth: 44.0),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadii.lg,
        border: border,
        boxShadow: (widget.variant == ArcoButtonVariant.primary && _isHovered)
            ? [
                BoxShadow(
                  color: AppColors.accentOrange.withOpacity(0.4),
                  blurRadius: 14,
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
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: fg,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: content,
      ),
    );
  }
}
