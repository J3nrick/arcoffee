import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_colors.dart';

/// Global controller to signal interactive hover state to the custom cursor.
class CursorController extends ChangeNotifier {
  static final CursorController instance = CursorController._();
  CursorController._();

  bool _isInteractive = false;
  bool get isInteractive => _isInteractive;

  void setInteractive(bool interactive) {
    if (_isInteractive == interactive) return;
    _isInteractive = interactive;
    notifyListeners();
  }
}

/// Web Custom Cursor replacing the default pointer with a fluid Apple HIG halo ring
/// that expands and snaps over interactive elements.
class CustomCursorWrapper extends StatefulWidget {
  final Widget child;

  const CustomCursorWrapper({super.key, required this.child});

  @override
  State<CustomCursorWrapper> createState() => _CustomCursorWrapperState();
}

class _CustomCursorWrapperState extends State<CustomCursorWrapper> {
  Offset _pointerPos = const Offset(-100, -100);
  bool _isInside = false;

  @override
  void initState() {
    super.initState();
    CursorController.instance.addListener(_onCursorUpdate);
  }

  @override
  void dispose() {
    CursorController.instance.removeListener(_onCursorUpdate);
    super.dispose();
  }

  void _onCursorUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Only activate custom cursor on Web or desktop pointer devices
    if (!kIsWeb) {
      return widget.child;
    }

    final isInteractive = CursorController.instance.isInteractive;
    final ringSize = isInteractive ? 42.0 : 20.0;
    final ringColor = isInteractive
        ? AppColors.accentOrange.withOpacity(0.85)
        : AppColors.primaryBlue.withOpacity(0.6);

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() => _isInside = true),
      onExit: (_) => setState(() => _isInside = false),
      onHover: (event) {
        setState(() {
          _pointerPos = event.position;
          _isInside = true;
        });
      },
      child: Stack(
        children: [
          widget.child,

          // Custom Follower Halo Overlay (Non-interactive, passes all clicks through)
          if (_isInside)
            Positioned(
              left: _pointerPos.dx - (ringSize / 2),
              top: _pointerPos.dy - (ringSize / 2),
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutCubic,
                  width: ringSize,
                  height: ringSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isInteractive
                        ? AppColors.accentOrange.withOpacity(0.15)
                        : CupertinoColors.transparent,
                    border: Border.all(
                      color: ringColor,
                      width: isInteractive ? 2.0 : 1.5,
                    ),
                    boxShadow: isInteractive
                        ? [
                            BoxShadow(
                              color: AppColors.accentOrange.withOpacity(0.4),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      width: isInteractive ? 0 : 4,
                      height: isInteractive ? 0 : 4,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Helper to wrap clickable widgets and notify the cursor to snap/expand.
class InteractiveHover extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const InteractiveHover({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => CursorController.instance.setInteractive(true),
      onExit: (_) => CursorController.instance.setInteractive(false),
      child: GestureDetector(
        onTap: onTap,
        child: child,
      ),
    );
  }
}
