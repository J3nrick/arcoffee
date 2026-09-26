import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';

/// Utility to display authentic Apple HIG CupertinoAlertDialog with retry action.
class AppleAlert {
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    VoidCallback? onRetry,
    String retryLabel = 'Try Again',
    String dismissLabel = 'Dismiss',
  }) async {
    return showCupertinoDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext ctx) {
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.exclamationmark_triangle_fill,
                  color: AppColors.accentOrange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                height: 1.35,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                dismissLabel,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ),
            if (onRetry != null)
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onRetry();
                },
                child: Text(
                  retryLabel,
                  style: const TextStyle(
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
