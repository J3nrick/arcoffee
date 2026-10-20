import 'package:flutter/cupertino.dart';
import '../../core/design/app_breakpoints.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import 'arco_text_link.dart';

/// Full-screen photograph viewer: the plate, its caption, and nothing else.
Future<void> showArcoLightbox(
  BuildContext context, {
  required String asset,
  required String title,
  String story = '',
}) {
  return showCupertinoModalPopup<void>(
    context: context,
    barrierColor: const Color(0xF507111D),
    builder: (ctx) {
      final pad = AppBreakpoints.horizontalPadding(ctx);
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(pad, 12, pad, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.scoreboard.copyWith(
                        fontSize: 12,
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentOrange,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  ArcoTextLink(
                    label: 'Close',
                    trailing: '×',
                    onTap: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: InteractiveViewer(
                  maxScale: 4,
                  child: Center(child: Image.asset(asset, fit: BoxFit.contain)),
                ),
              ),
              if (story.isNotEmpty) ...[
                const SizedBox(height: 18),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    story,
                    style: AppTypography.body.copyWith(
                      fontSize: 14,
                      height: 1.55,
                      color: AppColors.warmCream.withValues(alpha: 0.8),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
