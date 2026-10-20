import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../core/network/api_client.dart';
import '../../core/utils/image_precacher.dart';
import '../../data/repositories/gallery_repository.dart';
import '../../data/repositories/menu_repository.dart';
import '../../data/repositories/store_repository.dart';
import '../../data/services/gallery_service.dart';
import '../../data/services/menu_service.dart';
import '../../data/services/store_service.dart';
import '../app_scaffold.dart';

/// "The Lob": Arcoffee's opening sequence.
///
/// The logo's swoosh is the flight of a pickleball. A ball is lobbed across
/// the night court, its flight drawing the arc; it lands in the "A", rings
/// ripple out from the landing, the mark settles under a court-light glow and
/// the community lines in. On exit the mark zooms through the camera into the site.
///
/// Court QR scans (?source=qr, ?court=N) get a sub-second version that opens on the Menu.
class SplashScreen extends StatefulWidget {
  final Widget? homeScreen;

  const SplashScreen({super.key, this.homeScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _t;
  late final AnimationController _breath;
  Timer? _navigationTimer;
  bool _isNavigating = false;
  bool _started = false;
  bool _isQrBypass = false;
  int _initialTabIndex = 0;

  static const String _logoAsset = 'assets/images/logo_orange.png';
  static const Color _night = Color(0xFF07111D);
  static const List<String> _community = ['COFFEE', 'COMMUNITY', 'SPORT', 'NIGHTLIFE'];

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    final source = uri.queryParameters['source']?.toLowerCase();
    // Printed court QR codes may carry ?order=court or ?court=N; they open straight on the Menu.
    final order = uri.queryParameters['order']?.toLowerCase();
    final court = uri.queryParameters['court'];
    _isQrBypass = source == 'qr' || order == 'court' || (court != null && court.isNotEmpty);
    _initialTabIndex = _isQrBypass ? 1 : 0;

    _t = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _isQrBypass ? 900 : 3600),
    );
    _breath = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    precacheImage(const AssetImage(_logoAsset), context);
    ImagePrecacher.precacheCoreAssets(context);

    if (MediaQuery.of(context).disableAnimations) {
      _t.value = 1;
      _navigationTimer = Timer(const Duration(milliseconds: 1200), _navigateToHome);
      return;
    }
    _t.forward().whenComplete(() {
      if (!mounted) return;
      _breath.repeat(reverse: true);
      _navigationTimer = Timer(Duration(milliseconds: _isQrBypass ? 150 : 700), _navigateToHome);
    });
  }

  void _navigateToHome() {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;
    final target = widget.homeScreen ??
        _createDefaultHomeScreen(initialTabIndex: _initialTabIndex);
    final reduced = MediaQuery.of(context).disableAnimations;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: reduced ? 300 : (_isQrBypass ? 600 : 1300)),
        pageBuilder: (context, animation, secondaryAnimation) => target,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // The site arrives once the zooming mark has filled the frame.
          final fade = CurvedAnimation(parent: animation, curve: const Interval(0.42, 1.0, curve: Curves.easeOutCubic));
          final scale = Tween<double>(begin: 1.06, end: 1.0)
              .animate(CurvedAnimation(parent: animation, curve: const Interval(0.42, 1.0, curve: Curves.easeOutQuart)));
          return FadeTransition(opacity: fade, child: ScaleTransition(scale: scale, child: child));
        },
      ),
    );
  }

  Widget _createDefaultHomeScreen({int initialTabIndex = 0}) {
    final apiClient = ApiClient();
    return AppScaffold(
      menuRepository: AppMenuRepository(menuService: MenuService(apiClient: apiClient)),
      storeRepository: AppStoreRepository(storeService: StoreService(apiClient: apiClient)),
      galleryRepository: AppGalleryRepository(galleryService: GalleryService(apiClient: apiClient)),
      initialTabIndex: initialTabIndex,
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _t.dispose();
    _breath.dispose();
    super.dispose();
  }

  /// Progress of [_t] within [a]..[b], eased.
  double _seg(double a, double b, [Curve curve = Curves.easeOutCubic]) =>
      curve.transform(((_t.value - a) / (b - a)).clamp(0.0, 1.0));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logoW = math.min(size.width * 0.62, 420.0);
    final logoH = logoW / 2.2875;
    final exit = ModalRoute.of(context)?.secondaryAnimation ?? kAlwaysDismissedAnimation;

    return Scaffold(
      backgroundColor: _night,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToHome,
        child: Semantics(
          label: 'Arcoffee. ${AppConstants.slogan} Tap to enter.',
          child: AnimatedBuilder(
            animation: Listenable.merge([_t, _breath, exit]),
            builder: (context, _) {
              final out = Curves.easeInCubic.transform(exit.value);
              final chromeFade = 1 - (exit.value / 0.3).clamp(0.0, 1.0);
              final flight = _seg(0.10, 0.50, Curves.easeInOutSine);
              final landed = _seg(0.46, 0.62);
              final breath = Curves.easeInOutSine.transform(_breath.value);
              // One rect places both the painted flight and the logo image, so the trail hands off exactly.
              final logoRect = Rect.fromCenter(
                center: Offset(size.width / 2, size.height * 0.42),
                width: logoW,
                height: logoH,
              );

              return Stack(
                fit: StackFit.expand,
                children: [
                  // Night court light: a soft pool that blooms on landing.
                  Opacity(
                    opacity: 1 - (exit.value - 0.5).clamp(0.0, 0.5) * 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.12),
                          radius: 0.9,
                          colors: [
                            Color.lerp(const Color(0xFF10283E), AppColors.accentOrange, 0.10 * landed + 0.04 * breath)!,
                            _night,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Court lines, ripples, ball and flight trail.
                  Opacity(
                    opacity: chromeFade,
                    child: CustomPaint(
                      painter: _LobPainter(
                        logoRect: logoRect,
                        lines: _seg(0.0, 0.22),
                        flight: flight,
                        trailFade: 1 - landed,
                        ripples: _t.value,
                        breath: breath,
                      ),
                    ),
                  ),

                  // Mark: settles on landing, zooms through the camera on exit.
                  Positioned.fromRect(
                    rect: logoRect,
                    child: Transform.scale(
                      scale: (0.94 + 0.06 * landed + 0.015 * breath) * (1 + 22 * out),
                      child: Opacity(
                        opacity: landed * (1 - (exit.value - 0.7).clamp(0.0, 0.3) / 0.3),
                        child: Image.asset(_logoAsset, fit: BoxFit.fill, filterQuality: FilterQuality.high),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: logoRect.bottom + logoH * 0.42,
                    child: Opacity(opacity: chromeFade, child: Center(child: _wordmark(logoW))),
                  ),

                  // Footer: community words and the loading hairline.
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: math.max(32, size.height * 0.07),
                    child: Opacity(
                      opacity: chromeFade,
                      child: Column(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 18,
                            runSpacing: 8,
                            children: [
                              for (var i = 0; i < _community.length; i++)
                                Opacity(
                                  opacity: _seg(0.74 + i * 0.05, 0.88 + i * 0.03),
                                  child: Text(
                                    _community[i],
                                    style: AppTypography.scoreboard.copyWith(
                                      fontSize: 10.5,
                                      letterSpacing: 2.6,
                                      fontWeight: FontWeight.w700,
                                      color: i == 1 ? AppColors.accentOrange : AppColors.warmCream.withValues(alpha: 0.6),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: 120,
                            height: 1,
                            child: Stack(
                              children: [
                                Container(color: AppColors.warmCream.withValues(alpha: 0.12)),
                                FractionallySizedBox(
                                  widthFactor: _t.value,
                                  child: Container(color: AppColors.accentOrange),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _wordmark(double logoW) {
    const word = 'ARCOFFEE';
    final spread = _seg(0.58, 0.86, Curves.easeOutQuart);
    final fontSize = (logoW * 0.11).clamp(20.0, 40.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < word.length; i++)
              Opacity(
                opacity: _seg(0.58 + i * 0.022, 0.72 + i * 0.022),
                child: Transform.translate(
                  offset: Offset(0, 14 * (1 - _seg(0.58 + i * 0.022, 0.76 + i * 0.022))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: fontSize * (0.12 + 0.3 * (1 - spread))),
                    child: Text(
                      word[i],
                      style: AppTypography.displayXL.copyWith(
                        fontSize: fontSize,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                        color: AppColors.warmCream,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Opacity(
          opacity: _seg(0.70, 0.88),
          child: Text(
            AppConstants.slogan,
            style: AppTypography.bodyLarge.copyWith(
              fontSize: (fontSize * 0.5).clamp(14.0, 19.0),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: AppColors.accentOrange,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

/// Paints the night-court scene: baseline, the ball's flight, and landing ripples.
class _LobPainter extends CustomPainter {
  final Rect logoRect;
  final double lines;
  final double flight;
  final double trailFade;
  final double ripples;
  final double breath;

  _LobPainter({
    required this.logoRect,
    required this.lines,
    required this.flight,
    required this.trailFade,
    required this.ripples,
    required this.breath,
  });

  // The swoosh in the logo's own 366 x 160 space, as one cubic.
  Path _flightPath() {
    Offset p(double x, double y) => Offset(logoRect.left + x / 366 * logoRect.width, logoRect.top + y / 160 * logoRect.height);
    final a = p(12, 124), b = p(60, 30), c = p(200, 8), d = p(272, 102);
    return Path()
      ..moveTo(a.dx, a.dy)
      ..cubicTo(b.dx, b.dy, c.dx, c.dy, d.dx, d.dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    const cream = AppColors.warmCream;
    const orange = AppColors.accentOrange;

    // Court baseline and service ticks draw outward from the centre.
    final baseY = logoRect.bottom + logoRect.height * 0.12;
    final half = size.width * 0.42 * lines;
    final linePaint = Paint()
      ..color = cream.withValues(alpha: 0.14)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(size.width / 2 - half, baseY), Offset(size.width / 2 + half, baseY), linePaint);
    for (final dx in [-0.28, 0.28]) {
      final x = size.width / 2 + size.width * dx * lines;
      canvas.drawLine(Offset(x, baseY - 8 * lines), Offset(x, baseY + 8 * lines), linePaint);
    }

    // Landing ripples: three rings from the mark, like a ball hitting still water.
    final centre = logoRect.center;
    for (var i = 0; i < 3; i++) {
      final r = ((ripples - 0.48 - i * 0.07) / 0.45).clamp(0.0, 1.0);
      if (r <= 0 || r >= 1) continue;
      final eased = Curves.easeOutCubic.transform(r);
      canvas.drawCircle(
        centre,
        logoRect.width * (0.35 + 0.95 * eased),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = orange.withValues(alpha: 0.55 * (1 - r)),
      );
    }

    // A steady ring that settles round the mark once it has landed (the video's ring, our court circle).
    final settle = ((ripples - 0.56) / 0.3).clamp(0.0, 1.0);
    if (settle > 0) {
      final ringRect = Rect.fromCircle(center: centre, radius: logoRect.width * (0.62 + 0.01 * breath));
      canvas.drawArc(
        ringRect,
        -math.pi / 2,
        2 * math.pi * Curves.easeInOutCubic.transform(settle),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = cream.withValues(alpha: 0.16),
      );
    }

    if (flight <= 0 || trailFade <= 0) return;

    // Flight trail: tapered, thickening toward the landing like the logo's swoosh.
    final metric = _flightPath().computeMetrics().first;
    final travelled = metric.length * flight;
    const segments = 48;
    for (var s = 0; s < segments; s++) {
      final t0 = s / segments, t1 = (s + 1) / segments;
      if (t0 * metric.length > travelled) break;
      final seg = metric.extractPath(t0 * metric.length, math.min(t1 * metric.length, travelled));
      canvas.drawPath(
        seg,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = logoRect.height * (0.03 + 0.11 * t1)
          ..color = orange.withValues(alpha: trailFade),
      );
    }

    // The ball, with a soft court-light glow.
    final ball = metric.getTangentForOffset(travelled)!.position;
    final ballR = logoRect.height * 0.055;
    canvas.drawCircle(
      ball,
      ballR * 3,
      Paint()
        ..color = orange.withValues(alpha: 0.25 * trailFade)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawCircle(ball, ballR, Paint()..color = cream.withValues(alpha: trailFade));
  }

  @override
  bool shouldRepaint(_LobPainter old) =>
      old.lines != lines ||
      old.flight != flight ||
      old.trailFade != trailFade ||
      old.ripples != ripples ||
      old.breath != breath ||
      old.logoRect != logoRect;
}
