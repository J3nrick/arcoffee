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
    // ==========================================
    // --- 1. COFFEE BASED — CLASSIC DRINKS ---
    // ==========================================
    const MenuItem(
      id: 'c1',
      name: 'Americano',
      description: 'Signature double shot of house espresso over crystal ice and purified mountain water. Crisp, bold, zero-sugar court focus.',
      category: MenuCategory.coffee,
      price: 110.0,
      hotPrice: 100.0,
      icedPrice: 110.0,
      isSignature: true,
      isCourtFavorite: true,
      tags: ['Signature Mark', 'Double Shot', 'Zero Sugar'],
      accentColor: AppColors.primaryBlue,
      caffeineNote: 'High Caffeine',
      size: 'Hot 12oz / Iced 16oz',
      imageAsset: 'assets/images/portafilter_tamp.jpg',
    ),
    const MenuItem(
      id: 'c2',
      name: 'Café Latte',
      description: 'Velvety micro-foamed milk folded over our double-shot espresso. Smooth, balanced, and timeless.',
      category: MenuCategory.coffee,
      price: 145.0,
      hotPrice: 135.0,
      icedPrice: 145.0,
      tags: ['Smooth Microfoam', 'Classic'],
      accentColor: AppColors.warmCoffee,
      caffeineNote: 'High Caffeine',
      size: 'Hot 12oz / Iced 16oz',
      imageAsset: 'assets/images/espresso_pour_latte.jpg',
    ),
    const MenuItem(
      id: 'c3',
      name: 'Spanish Latte',
      description: 'Rich dark espresso folded with sweet condensed milk and creamy textured milk. The iconic courtside crowd-pleaser.',
      category: MenuCategory.coffee,
      price: 150.0,
      hotPrice: 140.0,
      icedPrice: 150.0,
      isBestseller: true,
      isCourtFavorite: true,
      isSignature: true,
      tags: ['Bestseller', 'Signature Mark', 'Sweet & Creamy'],
      accentColor: AppColors.accentOrange,
      caffeineNote: 'High Caffeine',
      size: 'Hot 12oz / Iced 16oz',
      imageAsset: 'assets/images/latte_pull_portrait.png',
    ),

    // ==========================================
    // --- 2. COFFEE BASED — PREMIUM DRINKS ---
    // ==========================================
    const MenuItem(
      id: 'c4',
      name: 'Mocha',
      description: 'Pure artisanal dark cacao blended seamlessly with bold espresso and chilled fresh whole milk.',
      category: MenuCategory.coffee,
      price: 165.0,
      hotPrice: 160.0,
      icedPrice: 165.0,
      tags: ['Dark Cacao', 'Rich & Decadent'],
      accentColor: Color(0xFF4E342E),
      caffeineNote: 'High Caffeine',
      size: 'Hot 12oz / Iced 16oz',
      imageAsset: 'assets/images/espresso_crema_latte.png',
    ),
    const MenuItem(
      id: 'c5',
      name: 'White Mocha',
      description: 'Decadent white chocolate confection balanced by our signature roast espresso float and textured milk.',
      category: MenuCategory.coffee,
      price: 170.0,
      hotPrice: 165.0,
      icedPrice: 170.0,
      isSignature: true,
      isBestseller: true,
      tags: ['Signature Mark', 'White Chocolate Velvet'],
      accentColor: Color(0xFF8D6E63),
      caffeineNote: 'High Caffeine',
      size: 'Hot 12oz / Iced 16oz',
      imageAsset: 'assets/images/spanish_latte_mascot.jpg',
    ),
    const MenuItem(
      id: 'c6',
      name: 'Caramel Macchiato',
      description: 'Layered vanilla-infused milk marked with double espresso and generous artisanal caramel drizzle on top.',
      category: MenuCategory.coffee,
      price: 160.0,
      hotPrice: 155.0,
      icedPrice: 160.0,
      isSignature: true,
      isBestseller: true,
      tags: ['Signature Mark', 'Layered Float', 'Artisanal Caramel'],
      accentColor: AppColors.warmCoffee,
      caffeineNote: 'High Caffeine',
      size: 'Hot 12oz / Iced 16oz',
      imageAsset: 'assets/images/syrup_scale_prep.png',
    ),
    const MenuItem(
      id: 'c7',
      name: 'Oatside Spanish Latte',
      description: 'Plant-based luxury: velvety Oatside barista oat milk paired with sweet Spanish condensed notes and double espresso.',
      category: MenuCategory.coffee,
      price: 170.0,
      hotPrice: 165.0,
      icedPrice: 170.0,
      isSignature: true,
      isNew: true,
      tags: ['Signature Mark', 'Oatside Oat Milk', 'Plant-Based Option'],
      accentColor: Color(0xFFD7CCC8),
      caffeineNote: 'High Caffeine',
      size: 'Hot 12oz / Iced 16oz',
      imageAsset: 'assets/images/mango_americano_espresso.jpg',
    ),
    const MenuItem(
      id: 'c8',
      name: 'Mango Americano',
      description: 'Our viral courtside specialty! Sweet golden mango fruit base crowned with a floating double espresso shot.',
      category: MenuCategory.coffee,
      price: 140.0,
      formattedPrice: '₱140',
      isSignature: true,
      isBestseller: true,
      isCourtFavorite: true,
      isNew: true,
      tags: ['Signature Specialty', 'Bar Counter Favorite', 'Two-Tone Layer'],
      accentColor: Color(0xFFFFB300),
      caffeineNote: 'High Caffeine',
      size: '16 oz Iced',
      imageAsset: 'assets/images/mango_americano_counter.jpg',
    ),

    // ==========================================
    // --- 3. NON-COFFEE — CHOCOLATE SERIES ---
    // ==========================================
    const MenuItem(
      id: 'nc1',
      name: 'Milo Overload',
      description: 'A nostalgic malt chocolate mountain: rich chocolate milk base, decadent chocolate drizzle, and mounds of raw Milo powder.',
      category: MenuCategory.nonCoffee,
      price: 140.0,
      price16oz: 140.0,
      price22oz: 165.0,
      isBestseller: true,
      isCourtFavorite: true,
      isSignature: true,
      tags: ['Bestseller', 'Signature Mark', 'Milo Mountain', 'Caffeine-Free'],
      accentColor: Color(0xFF5D4037),
      caffeineNote: 'Caffeine-Free',
      size: '16oz / 22oz Iced',
      imageAsset: 'assets/images/milo_overload_court.png',
    ),
    const MenuItem(
      id: 'nc2',
      name: 'Ovaltine Rush',
      description: 'Toasted malt goodness, creamy milk base, thick chocolate drizzle, and crunchy toasted malt flakes.',
      category: MenuCategory.nonCoffee,
      price: 155.0,
      price16oz: 155.0,
      price22oz: 180.0,
      isSignature: true,
      isBestseller: true,
      tags: ['Signature Mark', 'Toasted Malt Crunch', 'Caffeine-Free'],
      accentColor: Color(0xFFD84315),
      caffeineNote: 'Caffeine-Free',
      size: '16oz / 22oz Iced',
      imageAsset: 'assets/images/stand_poster_specials.png',
    ),

    // ==========================================
    // --- 4. NON-COFFEE — SODA SERIES ---
    // ==========================================
    const MenuItem(
      id: 's1',
      name: 'Lychee Soda',
      description: 'Floral lychee syrup infused with effervescent sparkling soda, clear ice, and crisp carbonation. Post-match refresher.',
      category: MenuCategory.soda,
      price: 120.0,
      price16oz: 120.0,
      price22oz: 140.0,
      isBestseller: true,
      isCourtFavorite: true,
      tags: ['Effervescent', 'Floral Lychee', 'Zero Caffeine'],
      accentColor: Color(0xFFE040FB),
      caffeineNote: 'Zero Caffeine',
      size: '16oz / 22oz Iced',
      imageAsset: 'assets/images/lychee_soda_chat_paddle.jpg',
    ),
    const MenuItem(
      id: 's2',
      name: 'Green Apple Soda',
      description: 'Crisp, electric green Granny Smith apple syrup charged with sparkling soda bubbles. The ultimate post-rally revitalizer.',
      category: MenuCategory.soda,
      price: 100.0,
      price16oz: 100.0,
      price22oz: 120.0,
      isSignature: true,
      isCourtFavorite: true,
      tags: ['Signature Mark', 'Electric Tart', 'Zero Caffeine'],
      accentColor: Color(0xFF7CB342),
      caffeineNote: 'Zero Caffeine',
      size: '16oz / 22oz Iced',
      imageAsset: 'assets/images/green_apple_court_line.jpg',
    ),
    const MenuItem(
      id: 's3',
      name: 'Craft Soda Trio',
      description: 'The ultimate courtside tasting flight: sample three refreshing sparkling sodas prepared fresh on the court line.',
      category: MenuCategory.soda,
      price: 130.0,
      price16oz: 130.0,
      price22oz: 150.0,
      isSignature: true,
      tags: ['Flight Trio', 'Court Line Refresh', 'Zero Caffeine'],
      accentColor: Color(0xFF00ACC1),
      caffeineNote: 'Zero Caffeine',
      size: '16oz / 22oz Iced',
      imageAsset: 'assets/images/soda_trio_court.jpg',
    ),
    const MenuItem(
      id: 's4',
      name: 'Sparkling Fruit Soda',
      description: 'Artisanal studio-crafted carbonated refresher made with natural fruit purée and pure sparkling spring water.',
      category: MenuCategory.soda,
      price: 120.0,
      price16oz: 120.0,
      price22oz: 140.0,
      tags: ['Natural Fruit', 'Studio Crafted', 'Zero Caffeine'],
      accentColor: Color(0xFFFF7043),
      caffeineNote: 'Zero Caffeine',
      size: '16oz / 22oz Iced',
      imageAsset: 'assets/images/soda_series_studio.png',
    ),

    // ==========================================
    // --- 5. NON-COFFEE — MATCHA SERIES ---
    // ==========================================
    const MenuItem(
      id: 'm1',
      name: 'Haw-Haw Matcha',
      description: 'Our viral signature creation! Traditional ceremonial Uji matcha fused with the nostalgic milky sweet flavor of iconic Haw-Haw candy.',
      category: MenuCategory.matcha,
      price: 180.0,
      price16oz: 180.0,
      price22oz: 200.0,
      isBestseller: true,
      isCourtFavorite: true,
      isSignature: true,
      tags: ['Viral Signature', 'Signature Mark', 'Haw-Haw Milk', 'Cavite Exclusive'],
      accentColor: AppColors.matchaGreen,
      caffeineNote: 'Clean L-Theanine Energy',
      size: '16oz / 22oz Iced',
      imageAsset: 'assets/images/matcha_pour.png',
    ),
    const MenuItem(
      id: 'm2',
      name: 'Matcha Drift',
      description: 'Whisked ceremonial green tea poured over chilled sweet milk and topped with an airy, cloud-like matcha cold foam drift.',
      category: MenuCategory.matcha,
      price: 220.0,
      formattedPrice: '₱220',
      isSignature: true,
      isNew: true,
      tags: ['Ceremonial Grade', 'Signature Cold Foam Drift'],
      accentColor: Color(0xFF2E7D32),
      caffeineNote: 'Medium L-Theanine',
      size: '16 oz Iced',
      imageAsset: 'assets/images/matcha_pour.png',
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
