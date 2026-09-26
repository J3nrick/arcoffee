import 'package:flutter/cupertino.dart';
import '../../theme/theme_controller.dart';

/// Clean edge-to-edge application scaffold container adhering strictly to Apple HIG guidelines.
/// Does not spoof fake window titlebars or traffic light controls.
class MacOSWindowFrame extends StatelessWidget {
  final Widget child;
  final int activeIndex;
  final ValueChanged<int> onTabSelected;

  const MacOSWindowFrame({
    super.key,
    required this.child,
    required this.activeIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ThemeScope.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      color: theme.scaffoldBackground,
      child: SafeArea(
        top: false,
        bottom: true,
        child: child,
      ),
    );
  }
}
