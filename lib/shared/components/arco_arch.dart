import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_motion.dart';
import '../../core/design/app_typography.dart';

/// The brand's signature frame: a doorway arch (the "Arc" in Arcoffee).
class ArcoArch extends StatelessWidget {
  final Widget child;
  final double bottomRadius;

  const ArcoArch({super.key, required this.child, this.bottomRadius = 6});

  @override
  Widget build(BuildContext context) => ClipPath(clipper: _ArchClipper(bottomRadius), child: child);
}

class _ArchClipper extends CustomClipper<Path> {
  final double bottomRadius;
  const _ArchClipper(this.bottomRadius);

  @override
  Path getClip(Size s) => archPath(Offset.zero & s, bottomRadius);

  @override
  bool shouldReclip(_ArchClipper old) => old.bottomRadius != bottomRadius;
}

/// Arch outline for [r]: semicircular head the full width of the rect, square-ish foot.
Path archPath(Rect r, [double bottomRadius = 6]) {
  final radius = r.width / 2;
  return Path()
    ..moveTo(r.left, r.top + radius)
    ..arcToPoint(Offset(r.right, r.top + radius), radius: Radius.circular(radius))
    ..lineTo(r.right, r.bottom - bottomRadius)
    ..quadraticBezierTo(r.right, r.bottom, r.right - bottomRadius, r.bottom)
    ..lineTo(r.left + bottomRadius, r.bottom)
    ..quadraticBezierTo(r.left, r.bottom, r.left, r.bottom - bottomRadius)
    ..close();
}

/// A thin orange stroke drawn along part of a circle; [progress] 0..1 draws it on.
class ArcoArcStroke extends CustomPainter {
  final double progress;
  final double startAngle;
  final double sweep;
  final double strokeWidth;
  final Color color;

  const ArcoArcStroke({
    required this.progress,
    this.startAngle = math.pi * 0.75,
    this.sweep = math.pi * 1.1,
    this.strokeWidth = 2,
    this.color = AppColors.accentOrange,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    canvas.drawArc(
      rect,
      startAngle,
      sweep * progress,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(ArcoArcStroke old) =>
      old.progress != progress || old.color != color || old.startAngle != startAngle || old.sweep != sweep;
}

/// Slowly rotating circular seal: text set around a ring with the logo mark at its centre.
class ArcoSeal extends StatefulWidget {
  final String text;
  final double size;
  final Color color;

  /// Disc behind the seal so its lettering stays legible over type or photos.
  final Color? background;

  const ArcoSeal({super.key, required this.text, this.size = 112, this.color = AppColors.deepBlue, this.background});

  @override
  State<ArcoSeal> createState() => _ArcoSealState();
}

class _ArcoSealState extends State<ArcoSeal> with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(vsync: this, duration: const Duration(seconds: 24));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.isReducedMotion(context)) {
      _spin.stop();
    } else if (!_spin.isAnimating) {
      _spin.repeat();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.background != null)
              DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, color: widget.background),
                child: SizedBox.square(dimension: widget.size),
              ),
            RotationTransition(
              turns: _spin,
              child: CustomPaint(
                size: Size.square(widget.size),
                painter: _SealPainter(widget.text, widget.color),
              ),
            ),
            Image.asset(
              'assets/images/logo_orange.png',
              width: widget.size * 0.42,
              filterQuality: FilterQuality.medium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SealPainter extends CustomPainter {
  final String text;
  final Color color;
  _SealPainter(this.text, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final style = AppTypography.scoreboard.copyWith(
      fontSize: size.width * 0.085,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      color: color,
    );
    final step = 2 * math.pi / text.length;
    canvas.translate(r, r);
    for (var i = 0; i < text.length; i++) {
      final tp = TextPainter(text: TextSpan(text: text[i], style: style), textDirection: TextDirection.ltr)..layout();
      canvas.save();
      canvas.rotate(i * step);
      tp.paint(canvas, Offset(-tp.width / 2, -r + 2));
      canvas.restore();
    }
    canvas.drawCircle(
      Offset.zero,
      r * 0.7,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = color.withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(_SealPainter old) => old.text != text || old.color != color;
}

/// Outlined (stroked, unfilled) display type, for the vertical edge wordmark.
class ArcoOutlineText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const ArcoOutlineText(this.text, {super.key, required this.fontSize, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      softWrap: false,
      style: AppTypography.displayXL.copyWith(
        fontSize: fontSize,
        height: 1,
        fontWeight: FontWeight.w800,
        letterSpacing: -fontSize * 0.02,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = color,
      ),
    );
  }
}
