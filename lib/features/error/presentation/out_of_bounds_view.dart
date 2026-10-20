import 'package:flutter/cupertino.dart';
import '../../../shared/components/arco_button.dart';
import '../../../shared/components/arco_page_cover.dart';
import '../../../shared/components/arco_text_link.dart';

/// Custom 404 for Arcoffee: a line call, delivered as a full-bleed cover.
class OutOfBoundsView extends StatelessWidget {
  final VoidCallback onReturnToMenu;
  final VoidCallback? onReturnHome;

  const OutOfBoundsView({
    super.key,
    required this.onReturnToMenu,
    this.onReturnHome,
  });

  @override
  Widget build(BuildContext context) {
    return ArcoPageCover(
      index: 'CODE 404',
      kicker: 'FAULT CALLED  ·  LINE FOOT VIOLATION',
      title: 'OUT OF\nBOUNDS.',
      lede: "You've stepped past the baseline. No penalty assessed. Let's get you back on the court.",
      imageAsset: 'assets/images/green_apple_court_line.jpg',
      caption: 'PLATE — THE NON-VOLLEY LINE',
      heightFactor: 0.9,
      actions: [
        ArcoButton(
          text: "Back to the Menu →",
          onPressed: onReturnToMenu,
          variant: ArcoButtonVariant.primary,
        ),
        if (onReturnHome != null) ArcoTextLink(label: 'Home court', trailing: '', onTap: onReturnHome!),
      ],
    );
  }
}
