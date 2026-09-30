import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/network/api_client.dart';
import '../../core/utils/image_precacher.dart';
import '../../data/repositories/gallery_repository.dart';
import '../../data/repositories/menu_repository.dart';
import '../../data/repositories/store_repository.dart';
import '../../data/services/gallery_service.dart';
import '../../data/services/menu_service.dart';
import '../../data/services/order_tray_service.dart';
import '../../data/services/store_service.dart';
import '../app_scaffold.dart';

/// Luxury Editorial Splash Screen & Seamless Transition for ARCOFFEE.
///
/// Implements a 5-second cinematic brand experience:
/// - 0.0s - 1.2s: Fluid cinematic entrance (opacity 0 -> 1, scale 0.94 -> 1.0, subtle rise)
/// - 1.2s - 3.8s: Organic living breath with high-fashion editorial metadata reveal
/// - 3.8s - 5.0s: Masterful choreographed transition into the Home view:
///                Logo gently elevates (-30px) and expands (1.0 -> 1.08) while dissolving,
///                as AppScaffold floats upward and blooms seamlessly on the shared cream canvas.
///
/// Also handles instantaneous Court QR-code bypass when ?source=qr or ?order=court or ?court=X is detected.
class SplashScreen extends StatefulWidget {
  final Widget? homeScreen;

  const SplashScreen({
    super.key,
    this.homeScreen,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _breathController;

  late final Animation<double> _introFade;
  late final Animation<double> _introScale;
  late final Animation<Offset> _introSlide;

  late final Animation<double> _breathScale;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;

  Timer? _navigationTimer;
  bool _isNavigating = false;
  bool _assetsPrecached = false;
  int _initialTabIndex = 0;
  String? _preselectedCourt;

  // Exact sampled cream background from the brand logo asset to ensure zero borders
  static const Color creamBackground = Color(0xFFFBF7EB);
  static const String logoAsset =
      'assets/547188584_122096374029023682_3566562690668451689_n_2.jpg';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_assetsPrecached) {
      _assetsPrecached = true;
      precacheImage(const AssetImage(logoAsset), context);
      ImagePrecacher.precacheCoreAssets(context);
    }
  }

  @override
  void initState() {
    super.initState();

    // Inspect URI parameters for court-side QR code bypass
    final uri = Uri.base;
    final source = uri.queryParameters['source']?.toLowerCase();
    final order = uri.queryParameters['order']?.toLowerCase();
    final court = uri.queryParameters['court'];

    final bool isQrBypass = source == 'qr' || order == 'court' || (court != null && court.isNotEmpty);
    if (court != null && court.isNotEmpty) {
      OrderTrayService.instance.setCourtNumber(court);
    }

    _initialTabIndex = isQrBypass ? 1 : 0;
    _preselectedCourt = court;

    // 1. Phase 1: Entrance animation
    _introController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: isQrBypass ? 500 : 1200),
    );

    final CurvedAnimation introDecel = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOutCubic,
    );

    _introFade = Tween<double>(begin: 0.0, end: 1.0).animate(introDecel);

    _introScale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutQuart,
      ),
    );

    _introSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.04),
      end: Offset.zero,
    ).animate(introDecel);

    // 2. Phase 2: Living breath & editorial metadata reveal
    _breathController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: isQrBypass ? 500 : 2600),
    );

    _breathScale = Tween<double>(begin: 1.0, end: 1.028).animate(
      CurvedAnimation(
        parent: _breathController,
        curve: Curves.easeInOutSine,
      ),
    );

    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _breathController,
        curve: const Interval(0.20, 0.65, curve: Curves.easeOut),
      ),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _breathController,
        curve: const Interval(0.20, 0.70, curve: Curves.easeOutCubic),
      ),
    );

    // Start intro immediately; chain living breath right after
    _introController.forward().then((_) {
      if (!mounted) return;
      _breathController.forward();
    });

    // 3. Phase 3: Trigger transition to target view
    // Normal visit: 3800ms hold + transition = ~5s cinematic sequence
    // QR code scan: snappy 700ms quick-flash right into Menu
    final splashHoldMs = isQrBypass ? 700 : 3800;
    _navigationTimer = Timer(Duration(milliseconds: splashHoldMs), _navigateToHome);
  }

  void _navigateToHome() {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;

    final targetScreen = widget.homeScreen ??
        _createDefaultHomeScreen(
          initialTabIndex: _initialTabIndex,
          preselectedCourt: _preselectedCourt,
        );

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: _initialTabIndex == 1 ? 600 : 1200),
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Luxury Apple Keynote-style transition:
          // Incoming screen floats upward and dissolves in smoothly
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutQuart,
          );

          final slideAnim = Tween<Offset>(
            begin: const Offset(0.0, 0.035),
            end: Offset.zero,
          ).animate(curved);

          final scaleAnim = Tween<double>(
            begin: 0.985,
            end: 1.0,
          ).animate(curved);

          final fadeAnim = CurvedAnimation(
            parent: animation,
            curve: const Interval(0.10, 1.0, curve: Curves.easeOutCubic),
          );

          return FadeTransition(
            opacity: fadeAnim,
            child: SlideTransition(
              position: slideAnim,
              child: ScaleTransition(
                scale: scaleAnim,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _createDefaultHomeScreen({int initialTabIndex = 0, String? preselectedCourt}) {
    final apiClient = ApiClient();
    final menuService = MenuService(apiClient: apiClient);
    final storeService = StoreService(apiClient: apiClient);
    final galleryService = GalleryService(apiClient: apiClient);

    return AppScaffold(
      menuRepository: AppMenuRepository(menuService: menuService),
      storeRepository: AppStoreRepository(storeService: storeService),
      galleryRepository: AppGalleryRepository(galleryService: galleryService),
      initialTabIndex: initialTabIndex,
      preselectedCourt: preselectedCourt,
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _introController.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the route is exiting to coordinate simultaneous outgoing motion
    final secondaryAnim = ModalRoute.of(context)?.secondaryAnimation;

    Widget body = Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_introController, _breathController]),
        builder: (context, _) {
          final double combinedScale = _introScale.value * _breathScale.value;

          return FadeTransition(
            opacity: _introFade,
            child: SlideTransition(
              position: _introSlide,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Iconic Arcoffee Brand Mark
                  Transform.scale(
                    scale: combinedScale,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 420,
                        maxHeight: 250,
                      ),
                      child: Image.asset(
                        logoAsset,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 2. High-Fashion Editorial Metadata Colophon
                  FadeTransition(
                    opacity: _taglineFade,
                    child: SlideTransition(
                      position: _taglineSlide,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Hairline court line
                          Container(
                            width: 36,
                            height: 1,
                            color: const Color(0xFF0B1B2B).withValues(alpha: 0.16),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'ARCOFFEE',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontFamilyFallback: [
                                '-apple-system',
                                'BlinkMacSystemFont',
                                'SF Pro Display',
                                'Inter',
                                'sans-serif',
                              ],
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4.8,
                              color: Color(0xFF0B1B2B),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'COURT-SIDE COFFEE CULTURE  •  THE PICKLEGROUND PH',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'JetBrains Mono',
                              fontFamilyFallback: [
                                'SF Mono',
                                'Menlo',
                                'Monaco',
                                'Consolas',
                                'monospace',
                              ],
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.2,
                              color: const Color(0xFFF36622).withValues(alpha: 0.95),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    // If route is exiting, orchestrate the splash elements lifting & dissolving
    if (secondaryAnim != null) {
      body = AnimatedBuilder(
        animation: secondaryAnim,
        builder: (context, child) {
          final exitCurved = CurvedAnimation(
            parent: secondaryAnim,
            curve: Curves.easeInCubic,
          );

          final exitFade = 1.0 - (exitCurved.value * 1.0);
          final exitSlideY = -0.06 * exitCurved.value;
          final exitScale = 1.0 + (exitCurved.value * 0.08);

          return Transform.translate(
            offset: Offset(0, exitSlideY * 300),
            child: Transform.scale(
              scale: exitScale,
              child: Opacity(
                opacity: exitFade.clamp(0.0, 1.0),
                child: child,
              ),
            ),
          );
        },
        child: body,
      );
    }

    return Scaffold(
      backgroundColor: creamBackground,
      // Tap anywhere to instantly trigger the smooth transition to Home if eager
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToHome,
        child: body,
      ),
    );
  }
}
