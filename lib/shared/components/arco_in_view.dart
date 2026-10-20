import 'package:flutter/cupertino.dart';
import '../../core/design/app_motion.dart';

/// Fades and lifts its child once, the first time it scrolls into the viewport.
/// With [builder], hands the eased 0..1 progress to the caller instead (for drawn strokes, counters).
class ArcoInView extends StatefulWidget {
  final Widget? child;
  final Widget Function(BuildContext context, double t)? builder;
  final Duration delay;
  final Duration duration;
  final double lift;

  const ArcoInView({
    super.key,
    this.child,
    this.builder,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 900),
    this.lift = 36,
  }) : assert(child != null || builder != null);

  @override
  State<ArcoInView> createState() => _ArcoInViewState();
}

class _ArcoInViewState extends State<ArcoInView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  ScrollPosition? _position;
  bool _triggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.isReducedMotion(context)) {
      _triggered = true;
      _controller.value = 1;
      return;
    }
    _position?.removeListener(_check);
    // The page scroll, not a horizontal carousel this may sit inside.
    _position = Scrollable.maybeOf(context, axis: Axis.vertical)?.position;
    _position?.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  bool _measureScheduled = false;

  // Scroll listeners fire before layout, so measure after the frame or positions are one scroll stale.
  void _check() {
    if (_triggered || _measureScheduled) return;
    _measureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureScheduled = false;
      _measure();
    });
  }

  void _measure() {
    if (_triggered || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.sizeOf(context).height * 0.94) {
      _triggered = true;
      _position?.removeListener(_check);
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return AnimatedBuilder(animation: _curve, builder: (context, _) => widget.builder!(context, _curve.value));
    }
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) => Opacity(
        opacity: _curve.value,
        child: Transform.translate(offset: Offset(0, widget.lift * (1 - _curve.value)), child: child),
      ),
    );
  }
}
