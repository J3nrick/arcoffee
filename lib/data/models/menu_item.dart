import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';

/// Supported Menu Categories for Arcoffee.
enum MenuCategory {
  all('All Items', 'All Drinks & Fuel', CupertinoIcons.sparkles),
  coffee('Coffee', 'Espresso & Cold Brews', CupertinoIcons.drop_fill),
  nonCoffee('Non-Coffee', 'Decaf & Signature Treats', CupertinoIcons.heart_fill),
  soda('Soda Series', 'Effervescent & Refreshing', CupertinoIcons.burst_fill),
  matcha('Matcha Series', 'Authentic Ceremonial Blends', CupertinoIcons.leaf_arrow_circlepath);

  final String displayName;
  final String description;
  final IconData icon;

  const MenuCategory(this.displayName, this.description, this.icon);

  static MenuCategory fromSlug(String slug) {
    switch (slug.toLowerCase()) {
      case 'coffee':
        return MenuCategory.coffee;
      case 'non-coffee':
      case 'noncoffee':
        return MenuCategory.nonCoffee;
      case 'soda-series':
      case 'soda':
        return MenuCategory.soda;
      case 'matcha-series':
      case 'matcha':
        return MenuCategory.matcha;
      default:
        return MenuCategory.all;
    }
  }

  String toSlug() {
    switch (this) {
      case MenuCategory.coffee:
        return 'coffee';
      case MenuCategory.nonCoffee:
        return 'non-coffee';
      case MenuCategory.soda:
        return 'soda-series';
      case MenuCategory.matcha:
        return 'matcha-series';
      case MenuCategory.all:
        return 'all';
    }
  }
}

/// Robust MenuItem entity ready for Laravel REST API serialization.
class MenuItem {
  final String id;
  final String name;
  final String description;
  final MenuCategory category;
  final double price;
  final String formattedPrice;
  final double? hotPrice;
  final double? icedPrice;
  final double? price16oz;
  final double? price22oz;
  final bool isBestseller;
  final bool isCourtFavorite;
  final bool isSignature;
  final bool isNew;
  final List<String> tags;
  final Color accentColor;
  final String size;
  final String caffeineNote;
  final String? imageAsset;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.formattedPrice = '',
    this.hotPrice,
    this.icedPrice,
    this.price16oz,
    this.price22oz,
    this.isBestseller = false,
    this.isCourtFavorite = false,
    this.isSignature = false,
    this.isNew = false,
    this.tags = const [],
    this.accentColor = AppColors.accentOrange,
    this.size = '16 oz (Grande)',
    this.caffeineNote = 'Moderate Caffeine',
    this.imageAsset,
  });

  String get displayPrice {
    if (formattedPrice.isNotEmpty) return formattedPrice;
    if (hotPrice != null && icedPrice != null) {
      return 'Hot ₱${hotPrice!.toStringAsFixed(0)} / Iced ₱${icedPrice!.toStringAsFixed(0)}';
    }
    if (price16oz != null && price22oz != null) {
      return '16oz ₱${price16oz!.toStringAsFixed(0)} / 22oz ₱${price22oz!.toStringAsFixed(0)}';
    }
    return '₱${price.toStringAsFixed(0)}';
  }

  /// Factory constructor for Laravel API payloads:
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: MenuCategory.fromSlug(json['category_slug'] ?? 'all'),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      formattedPrice: json['formatted_price'] ?? '',
      hotPrice: (json['hot_price'] as num?)?.toDouble(),
      icedPrice: (json['iced_price'] as num?)?.toDouble(),
      price16oz: (json['price_16oz'] as num?)?.toDouble(),
      price22oz: (json['price_22oz'] as num?)?.toDouble(),
      isBestseller: json['is_bestseller'] ?? false,
      isCourtFavorite: json['is_court_favorite'] ?? false,
      isSignature: json['is_signature'] ?? false,
      isNew: json['is_new'] ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      accentColor: _colorFromCategory(json['category_slug']),
      size: json['size'] ?? '16 oz (Grande)',
      caffeineNote: json['caffeine_note'] ?? 'Crafted Fresh',
      imageAsset: json['image_asset'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category_slug': category.toSlug(),
      'price': price,
      'formatted_price': displayPrice,
      'hot_price': hotPrice,
      'iced_price': icedPrice,
      'price_16oz': price16oz,
      'price_22oz': price22oz,
      'is_bestseller': isBestseller,
      'is_court_favorite': isCourtFavorite,
      'is_signature': isSignature,
      'is_new': isNew,
      'tags': tags,
      'size': size,
      'caffeine_note': caffeineNote,
      'image_asset': imageAsset,
    };
  }

  static Color _colorFromCategory(String? slug) {
    switch (slug?.toLowerCase()) {
      case 'matcha':
      case 'matcha-series':
        return AppColors.matchaGreen;
      case 'soda':
      case 'soda-series':
        return AppColors.sodaBlue;
      case 'coffee':
        return AppColors.warmCoffee;
      default:
        return AppColors.accentOrange;
    }
  }
}
