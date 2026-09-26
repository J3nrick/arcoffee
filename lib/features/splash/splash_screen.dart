import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/network/api_client.dart';
import '../../data/repositories/gallery_repository.dart';
import '../../data/repositories/menu_repository.dart';
import '../../data/repositories/store_repository.dart';
import '../../data/services/gallery_service.dart';
import '../../data/services/menu_service.dart';
import '../../data/services/store_service.dart';
import '../app_scaffold.dart';

/// High-performance, 60fps Native Splash Screen for Arcoffee.
/// Adheres strictly to Apple Human Interface Guidelines (HIG).
///
/// Animates the official static brand logo using native Flutter transitions
/// and transitions seamlessly into the Home screen after the sequence completes.
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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  Timer? _holdTimer;

  // Exact sampled cream background from the brand logo asset to ensure zero borders
  static const Color creamBackground = Color(0xFFFBF7EB);
  static const String logoAsset =
      'assets/547188584_122096374029023682_3566562690668451689_n_2.jpg';

  @override
  void initState() {
    super.initState();

    // 1. Initialize controller for 1000ms entrance animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // 2. Strict Apple HIG spring / easeOutCubic curve
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // 3. Opacity: 0.0 -> 1.0
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curvedAnimation);

    // 4. Scale: 0.95 -> 1.0
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(curvedAnimation);

    // 5. Trigger entrance animation in initState
    _controller.forward().then((_) {
      if (!mounted) return;
      // 6. Hold for 1500ms after entrance completes, then navigate
      _holdTimer = Timer(const Duration(milliseconds: 1500), _navigateToHome);
    });
  }

  void _navigateToHome() {
    if (!mounted) return;

    final targetScreen = widget.homeScreen ?? _createDefaultHomeScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: fade,
            child: child,
          );
        },
      ),
    );
  }

  Widget _createDefaultHomeScreen() {
    final apiClient = ApiClient();
    final menuService = MenuService(apiClient: apiClient);
    final storeService = StoreService(apiClient: apiClient);
    final galleryService = GalleryService(apiClient: apiClient);

    return AppScaffold(
      menuRepository: AppMenuRepository(menuService: menuService),
      storeRepository: AppStoreRepository(storeService: storeService),
      galleryRepository: AppGalleryRepository(galleryService: galleryService),
    );
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
                maxHeight: 260,
              ),
              child: Image.asset(
                logoAsset,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
