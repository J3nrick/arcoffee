import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/app_config.dart';
import '../models/menu_item.dart';
import '../services/menu_service.dart';

/// Abstract contract for menu operations.
abstract class MenuRepository {
  Future<List<MenuItem>> getMenuItems({MenuCategory category = MenuCategory.all});
  Future<MenuItem?> getMenuItemById(String id);
  Future<List<MenuItem>> getFeaturedItems();
  Future<List<MenuItem>> searchMenuItems(String query);
}

/// Hybrid repository supporting both in-memory mock catalog and live Laravel REST API.
/// Controlled dynamically via `AppConfig.useLiveApi`.
class AppMenuRepository implements MenuRepository {
  final MenuService? menuService;

  AppMenuRepository({this.menuService});

  static final List<MenuItem> _mockItems = [
    // --- COFFEE SERIES ---
    const MenuItem(
      id: 'c1',
      name: 'Spanish Latte',
      description: 'Velvety espresso paired with condensed milk and creamy textured milk. The ultimate courtside crowd pleaser.',
      category: MenuCategory.coffee,
      price: 130.0,
      isBestseller: true,
      isCourtFavorite: true,
      tags: ['Bestseller', 'Courtside Favorite', 'Sweet & Creamy'],
      accentColor: AppColors.warmCoffee,
      caffeineNote: 'High Caffeine',
      size: '16 oz Iced',
    ),
    const MenuItem(
      id: 'c2',
      name: 'Sea Salt Caramel Macchiato',
      description: 'Layered espresso over vanilla-infused milk, finished with homemade butter caramel and mineral sea salt flakes.',
      category: MenuCategory.coffee,
      price: 145.0,
      isBestseller: true,
      tags: ['Layered', 'Signature Drizzle'],
      accentColor: AppColors.warmCoffee,
      caffeineNote: 'High Caffeine',
      size: '16 oz Iced',
    ),
    const MenuItem(
      id: 'c3',
      name: 'Arcoffee Cold Brew Reserve',
      description: 'Slow-steeped for 18 hours using high-altitude Arabica beans. Notes of dark cacao, roasted nuts, and subtle brown sugar.',
      category: MenuCategory.coffee,
      price: 125.0,
      isCourtFavorite: true,
      tags: ['18h Steeped', 'Clean Finish', 'Pickleball Fuel'],
      accentColor: AppColors.deepNavy,
      caffeineNote: 'Very High Caffeine',
      size: '16 oz Cold Bottle',
    ),
    const MenuItem(
      id: 'c4',
      name: 'Iced Americano',
      description: 'Double shot of signature Arcoffee house roast pulled directly over crystal ice and purified mountain water.',
      category: MenuCategory.coffee,
      price: 105.0,
      tags: ['Zero Sugar', 'Pure Espresso'],
      accentColor: AppColors.primaryBlue,
      caffeineNote: 'High Caffeine',
      size: '16 oz Iced',
    ),
    const MenuItem(
      id: 'c5',
      name: 'Dirty Matcha Espresso',
      description: 'Precision layered ceremonial Uji matcha, farm-fresh milk, topped with a bold ristretto shot.',
      category: MenuCategory.coffee,
      price: 155.0,
      isNew: true,
      tags: ['Fusion', 'Visual Layers', 'Energy Boost'],
      accentColor: AppColors.matchaGreen,
      caffeineNote: 'Dual Energy',
      size: '16 oz Iced',
    ),

    // --- NON-COFFEE SERIES ---
    const MenuItem(
      id: 'nc1',
      name: 'Milo Overload',
      description: 'A nostalgic malt chocolate mountain featuring rich chocolate base, malt cream, and heaping mounds of raw Milo powder.',
      category: MenuCategory.nonCoffee,
      price: 135.0,
      isBestseller: true,
      isCourtFavorite: true,
      tags: ['Bestseller', 'Nostalgic', 'Crowd Hit'],
      accentColor: Color(0xFF5D4037),
      caffeineNote: 'Caffeine-Free',
      size: '16 oz Iced',
    ),
    const MenuItem(
      id: 'nc2',
      name: 'Ovaltine Rush',
      description: 'Toasted malt goodness blended with creamy Hokkaido milk, chocolate drizzle, and crunchy malt crunchies.',
      category: MenuCategory.nonCoffee,
      price: 135.0,
      isBestseller: true,
      tags: ['Crunchy Texture', 'Malt Infusion'],
      accentColor: Color(0xFFD84315),
      caffeineNote: 'Caffeine-Free',
      size: '16 oz Iced',
    ),
    const MenuItem(
      id: 'nc3',
      name: 'Strawberry Milk Cloud',
      description: 'House-made strawberry compote layered with sweet whole milk and crowned with dense whipped vanilla cream.',
      category: MenuCategory.nonCoffee,
      price: 140.0,
      isNew: true,
      tags: ['Real Berries', 'Cream Cloud'],
      accentColor: Color(0xFFE91E63),
      caffeineNote: 'Caffeine-Free',
      size: '16 oz Iced',
    ),
    const MenuItem(
      id: 'nc4',
      name: 'Dark Chocolate Truffle',
      description: 'Pure 70% dark Davao cacao melted into steamed and chilled milk, balancing decadent bitterness and velvety sweetness.',
      category: MenuCategory.nonCoffee,
      price: 130.0,
      tags: ['Davao Cacao', 'Rich & Creamy'],
      accentColor: Color(0xFF3E2723),
      caffeineNote: 'Low Caffeine',
      size: '16 oz Iced',
    ),

    // --- SODA SERIES ---
    const MenuItem(
      id: 's1',
      name: 'Lychee Sparkler',
      description: 'Floral lychee syrup infused with effervescent carbonation, crushed ice, and fresh mint leaves. Crisp and invigorating.',
      category: MenuCategory.soda,
      price: 120.0,
      isBestseller: true,
      isCourtFavorite: true,
      tags: ['Post-Match Refresher', 'Fizzy', 'Floral'],
      accentColor: Color(0xFFE040FB),
      caffeineNote: 'Zero Caffeine',
      size: '16 oz Iced Sparkler',
    ),
    const MenuItem(
      id: 's2',
      name: 'Green Apple Fizz',
      description: 'Crisp green Granny Smith apple infusion charged with sparkling bubbles and a hint of tart lime juice.',
      category: MenuCategory.soda,
      price: 120.0,
      isCourtFavorite: true,
      tags: ['Tart & Crisp', 'Hydrating', 'Pickleball Favorite'],
      accentColor: Color(0xFF7CB342),
      caffeineNote: 'Zero Caffeine',
      size: '16 oz Iced Sparkler',
    ),
    const MenuItem(
      id: 's3',
      name: 'Lemon Yuzu Spritz',
      description: 'Zesty Japanese yuzu paired with fresh lemon reduction, sparkling soda water, and citrus peels. High vitality.',
      category: MenuCategory.soda,
      price: 130.0,
      isBestseller: true,
      tags: ['Citrus Punch', 'Electrolytes', 'Bestseller'],
      accentColor: Color(0xFFFBC02D),
      caffeineNote: 'Zero Caffeine',
      size: '16 oz Iced Sparkler',
    ),
    const MenuItem(
      id: 's4',
      name: 'Blue Lagoon Cooler',
      description: 'Vibrant blue curacao essence, zesty lemonade fizz, and a slice of dried citrus. Cool ocean breeze in a cup.',
      category: MenuCategory.soda,
      price: 125.0,
      isNew: true,
      tags: ['Vibrant Blue', 'Tropical Chill'],
      accentColor: Color(0xFF0288D1),
      caffeineNote: 'Zero Caffeine',
      size: '16 oz Iced Sparkler',
    ),

    // --- MATCHA SERIES ---
    const MenuItem(
      id: 'm1',
      name: 'Haw-Haw Matcha',
      description: 'Our viral signature creation! Traditional ceremonial Uji matcha fused with the nostalgic milky sweet flavor of iconic Haw-Haw candy.',
      category: MenuCategory.matcha,
      price: 160.0,
      isBestseller: true,
      isCourtFavorite: true,
      tags: ['Viral Signature', 'Haw-Haw Milk', 'Cavite Exclusive'],
      accentColor: AppColors.matchaGreen,
      caffeineNote: 'Clean L-Theanine Energy',
      size: '16 oz Iced',
    ),
    const MenuItem(
      id: 'm2',
      name: 'Matcha Drift',
      description: 'Whisked ceremonial green tea poured over chilled sweet milk and topped with an airy, cloud-like matcha cold foam drift.',
      category: MenuCategory.matcha,
      price: 155.0,
      isBestseller: true,
      tags: ['Matcha Cold Foam', 'Ceremonial Grade'],
      accentColor: Color(0xFF2E7D32),
      caffeineNote: 'Medium L-Theanine',
      size: '16 oz Iced',
    ),
    const MenuItem(
      id: 'm3',
      name: 'Ceremonial Iced Matcha Latte',
      description: 'Pure, shade-grown Japanese matcha whisked with bamboo chasen, poured over cold fresh milk. Earthy, umami-rich perfection.',
      category: MenuCategory.matcha,
      price: 145.0,
      tags: ['100% Ceremonial', 'Umami Rich'],
      accentColor: AppColors.matchaGreen,
      caffeineNote: 'Clean Energy',
      size: '16 oz Iced',
    ),
    const MenuItem(
      id: 'm4',
      name: 'Strawberry Matcha Glow',
      description: 'A tri-color masterpiece: strawberry puree on the bottom, fresh white milk in the center, and vibrant matcha on top.',
      category: MenuCategory.matcha,
      price: 165.0,
      isNew: true,
      tags: ['Tri-Layer', 'Aesthetic', 'Berries & Green Tea'],
      accentColor: Color(0xFFD81B60),
      caffeineNote: 'Clean Energy',
      size: '16 oz Iced',
    ),
  ];

  @override
  Future<List<MenuItem>> getMenuItems({MenuCategory category = MenuCategory.all}) async {
    // If live API mode is enabled and service is present, query Laravel REST API
    if (AppConfig.useLiveApi && menuService != null) {
      return await menuService!.fetchMenuItems(
        categorySlug: category.toSlug(),
      );
    }

    // Testing / Mock mode
    if (AppConfig.simulateApiFailure) {
      throw const ApiException(
        message: 'Unable to reach Arcoffee servers. Failed to fetch menu items.',
        statusCode: 503,
      );
    }

    await Future.delayed(Duration(milliseconds: AppConfig.mockDelayMs));
    if (category == MenuCategory.all) {
      return List.unmodifiable(_mockItems);
    }
    return _mockItems.where((item) => item.category == category).toList();
  }

  @override
  Future<MenuItem?> getMenuItemById(String id) async {
    if (AppConfig.useLiveApi && menuService != null) {
      return await menuService!.fetchMenuItemById(id);
    }

    await Future.delayed(const Duration(milliseconds: 30));
    try {
      return _mockItems.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<MenuItem>> getFeaturedItems() async {
    if (AppConfig.useLiveApi && menuService != null) {
      return await menuService!.fetchFeaturedItems();
    }

    await Future.delayed(const Duration(milliseconds: 40));
    return _mockItems.where((item) => item.isBestseller || item.isCourtFavorite).take(6).toList();
  }

  @override
  Future<List<MenuItem>> searchMenuItems(String query) async {
    if (AppConfig.useLiveApi && menuService != null) {
      return await menuService!.fetchMenuItems(search: query);
    }

    await Future.delayed(const Duration(milliseconds: 50));
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return _mockItems;
    return _mockItems.where((item) {
      return item.name.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          item.tags.any((tag) => tag.toLowerCase().contains(q));
    }).toList();
  }
}

/// Alias for backwards compatibility
typedef MockMenuRepository = AppMenuRepository;
