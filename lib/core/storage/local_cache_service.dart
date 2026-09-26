import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/gallery_item.dart';
import '../../data/models/menu_item.dart';
import '../../data/models/store_info.dart';

/// Local storage cache engine providing offline-first resilience for PWA and mobile.
class LocalCacheService {
  static const String _keyMenuPrefix = 'arcoffee_cache_menu_';
  static const String _keyGallery = 'arcoffee_cache_gallery';
  static const String _keyStore = 'arcoffee_cache_store';
  static const String _keyLikes = 'arcoffee_cache_likes';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Cache list of menu items
  Future<void> cacheMenuItems(String categorySlug, List<MenuItem> items) async {
    await init();
    final jsonList = items.map((item) => item.toJson()).toList();
    await _prefs?.setString('$_keyMenuPrefix$categorySlug', jsonEncode(jsonList));
  }

  /// Retrieve cached menu items
  List<MenuItem>? getCachedMenuItems(String categorySlug) {
    final raw = _prefs?.getString('$_keyMenuPrefix$categorySlug');
    if (raw == null || raw.isEmpty) return null;

    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded
          .map((json) => MenuItem.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Cache gallery feed
  Future<void> cacheGalleryItems(List<GalleryItem> items) async {
    await init();
    final jsonList = items.map((item) => item.toJson()).toList();
    await _prefs?.setString(_keyGallery, jsonEncode(jsonList));
  }

  /// Retrieve cached gallery feed
  List<GalleryItem>? getCachedGalleryItems() {
    final raw = _prefs?.getString(_keyGallery);
    if (raw == null || raw.isEmpty) return null;

    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded
          .map((json) => GalleryItem.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Cache store information
  Future<void> cacheStoreInfo(StoreInfo store) async {
    await init();
    await _prefs?.setString(_keyStore, jsonEncode(store.toJson()));
  }

  /// Retrieve cached store information
  StoreInfo? getCachedStoreInfo() {
    final raw = _prefs?.getString(_keyStore);
    if (raw == null || raw.isEmpty) return null;

    try {
      return StoreInfo.fromJson(Map<String, dynamic>.from(jsonDecode(raw)));
    } catch (_) {
      return null;
    }
  }

  /// Save user's liked posts
  Future<void> saveLikedIds(Set<String> ids) async {
    await init();
    await _prefs?.setStringList(_keyLikes, ids.toList());
  }

  /// Load user's liked posts
  Set<String> getLikedIds() {
    final list = _prefs?.getStringList(_keyLikes);
    return list != null ? list.toSet() : {};
  }
}
