import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_typography.dart';

/// Editorial text link: label with an orange hairline that stretches on hover.
/// Used instead of a secondary button wherever typography can carry the action (44pt hit area).
class ArcoTextLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final String trailing;

  const ArcoTextLink({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.warmCream,
    this.trailing = '↗',
  });

  @override
  State<ArcoTextLink> createState() => _ArcoTextLinkState();
}

class _ArcoTextLinkState extends State<ArcoTextLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.trailing.isEmpty ? widget.label : "${widget.label}  ${widget.trailing}",
                  style: AppTypography.body.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: widget.color,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: AppMotion.emphasis,
                  curve: AppMotion.defaultCurve,
                  height: 1.2,
                  width: _hover ? 140 : 36,
                  color: AppColors.accentOrange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
