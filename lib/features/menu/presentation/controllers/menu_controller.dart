import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/state/view_state.dart';
import '../../../../core/storage/local_cache_service.dart';
import '../../../../data/models/menu_item.dart';
import '../../../../data/repositories/menu_repository.dart';

/// State Controller managing the Menu View lifecycle, category filtering,
/// live search, and offline-first stale-while-revalidate caching.
class MenuViewController extends ChangeNotifier {
  final MenuRepository _repository;
  final LocalCacheService _cacheService;

  ViewState<List<MenuItem>> _state = ViewState.initial();
  MenuCategory _selectedCategory = MenuCategory.all;
  String _searchQuery = '';

  MenuViewController({
    required MenuRepository repository,
    LocalCacheService? cacheService,
  })  : _repository = repository,
        _cacheService = cacheService ?? LocalCacheService();

  ViewState<List<MenuItem>> get state => _state;
  MenuCategory get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  /// Load menu items using an offline-first stale-while-revalidate pattern.
  Future<void> loadMenu({bool isRetry = false}) async {
    final slug = _selectedCategory.toSlug();

    // 1. Immediately read from offline local cache
    final cached = _cacheService.getCachedMenuItems(slug);
    if (cached != null && cached.isNotEmpty && !isRetry) {
      _state = ViewState.loaded(cached);
      notifyListeners();
    } else {
      _state = ViewState.loading(_state.data);
      notifyListeners();
    }

    // 2. Silently fetch latest data from repository / Laravel API in the background
    try {
      final freshItems = await _repository.getMenuItems(category: _selectedCategory);
      _state = ViewState.loaded(freshItems);
      // Persist to local cache
      await _cacheService.cacheMenuItems(slug, freshItems);
      notifyListeners();
    } on ApiException catch (e) {
      // If we already have cached data, keep showing it and don't block the user
      if (_state.data != null && _state.data!.isNotEmpty) {
        // Soft error warning
      } else {
        _state = ViewState.error(e.message, _state.data);
        notifyListeners();
      }
    } catch (e) {
      if (_state.data == null || _state.data!.isEmpty) {
        _state = ViewState.error(
          'Unable to load the Arcoffee menu. Please check your internet connection.',
          _state.data,
        );
        notifyListeners();
      }
    }
  }

  /// Change active category filter and reload.
  void selectCategory(MenuCategory category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
    loadMenu();
  }

  /// Update search query and trigger instant client filtering.
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Filtered menu items according to search query.
  List<MenuItem> get filteredItems {
    final rawList = _state.data ?? [];
    if (_searchQuery.isEmpty) return rawList;

    final q = _searchQuery.toLowerCase().trim();
    return rawList.where((item) {
      return item.name.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          item.tags.any((tag) => tag.toLowerCase().contains(q));
    }).toList();
  }

  /// Retry fetching menu after error
  Future<void> retry() => loadMenu(isRetry: true);
}
