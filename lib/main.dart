import 'package:flutter/cupertino.dart';
import 'core/network/api_client.dart';
import 'data/repositories/gallery_repository.dart';
import 'data/repositories/menu_repository.dart';
import 'data/repositories/store_repository.dart';
import 'data/services/gallery_service.dart';
import 'data/services/menu_service.dart';
import 'data/services/store_service.dart';
import 'features/app_scaffold.dart';
import 'features/splash/splash_screen.dart';
import 'shared/widgets/custom_cursor.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArcoffeeApp());
}

/// Root Application configured strictly with Apple Human Interface Guidelines (HIG).
class ArcoffeeApp extends StatefulWidget {
  const ArcoffeeApp({super.key});

  @override
  State<ArcoffeeApp> createState() => _ArcoffeeAppState();
}

class _ArcoffeeAppState extends State<ArcoffeeApp> {
  late final ThemeController _themeController;
  late final ApiClient _apiClient;
  late final MenuService _menuService;
  late final StoreService _storeService;
  late final GalleryService _galleryService;

  late final AppMenuRepository _menuRepository;
  late final AppStoreRepository _storeRepository;
  late final AppGalleryRepository _galleryRepository;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();

    // Network layer infrastructure
    _apiClient = ApiClient();
    _menuService = MenuService(apiClient: _apiClient);
    _storeService = StoreService(apiClient: _apiClient);
    _galleryService = GalleryService(apiClient: _apiClient);

    // Hybrid repositories
    _menuRepository = AppMenuRepository(menuService: _menuService);
    _storeRepository = AppStoreRepository(storeService: _storeService);
    _galleryRepository = AppGalleryRepository(galleryService: _galleryService);
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        return ThemeScope(
          controller: _themeController,
          child: CupertinoApp(
            title: "Arcoffee | It's always been ours.",
            debugShowCheckedModeBanner: false,
            theme: _themeController.isMidnightCourt
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
            builder: (context, child) {
              return CustomCursorWrapper(
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: SplashScreen(
              homeScreen: AppScaffold(
                menuRepository: _menuRepository,
                storeRepository: _storeRepository,
                galleryRepository: _galleryRepository,
              ),
            ),
          ),
        );
      },
    );
  }
}
