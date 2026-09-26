import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/state/view_state.dart';
import '../../../../core/storage/local_cache_service.dart';
import '../../../../data/models/gallery_item.dart';
import '../../../../data/repositories/gallery_repository.dart';

/// State Controller managing the Community Gallery lifecycle, masonry items,
/// and offline-first state persistence.
class GalleryViewController extends ChangeNotifier {
  final GalleryRepository _repository;
  final LocalCacheService _cacheService;

  ViewState<List<GalleryItem>> _state = ViewState.initial();
  final Set<String> _likedIds = {};

  GalleryViewController({
    required GalleryRepository repository,
    LocalCacheService? cacheService,
  })  : _repository = repository,
        _cacheService = cacheService ?? LocalCacheService() {
    _initLikes();
  }

  ViewState<List<GalleryItem>> get state => _state;
  Set<String> get likedIds => _likedIds;

  bool isLiked(String id) => _likedIds.contains(id);

  void _initLikes() {
    final saved = _cacheService.getLikedIds();
    _likedIds.addAll(saved);
  }

  /// Load gallery feed using stale-while-revalidate caching.
  Future<void> loadGallery({bool isRetry = false}) async {
    // 1. Immediately display cached polaroid gallery if available
    final cached = _cacheService.getCachedGalleryItems();
    if (cached != null && cached.isNotEmpty && !isRetry) {
      _state = ViewState.loaded(cached);
      notifyListeners();
    } else {
      _state = ViewState.loading(_state.data);
      notifyListeners();
    }

    // 2. Silently fetch latest community feed
    try {
      final freshItems = await _repository.getGalleryItems();
      _state = ViewState.loaded(freshItems);
      await _cacheService.cacheGalleryItems(freshItems);
      notifyListeners();
    } on ApiException catch (e) {
      if (_state.data == null || _state.data!.isEmpty) {
        _state = ViewState.error(e.message, _state.data);
        notifyListeners();
      }
    } catch (e) {
      if (_state.data == null || _state.data!.isEmpty) {
        _state = ViewState.error(
          'Unable to load community gallery feed. Please retry.',
          _state.data,
        );
        notifyListeners();
      }
    }
  }

  /// Toggle like action optimistically and sync with backend and local storage.
  Future<void> toggleLike(String id) async {
    if (_likedIds.contains(id)) {
      _likedIds.remove(id);
    } else {
      _likedIds.add(id);
    }
    notifyListeners();
    await _cacheService.saveLikedIds(_likedIds);

    try {
      await _repository.toggleLike(id);
    } catch (_) {
      // Keep optimistic state
    }
  }

  /// Retry fetching gallery
  Future<void> retry() => loadGallery(isRetry: true);
}
