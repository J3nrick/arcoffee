import 'package:flutter/foundation.dart';
import '../../core/storage/local_cache_service.dart';
import '../models/menu_item.dart';

/// The visitor's Court Card: drinks they've picked to show at the bar.
/// Not an order. Nothing is sent anywhere; ids persist on this device only.
class CourtCardService extends ChangeNotifier {
  static final CourtCardService instance = CourtCardService._(LocalCacheService());

  CourtCardService._(this._cache);

  final LocalCacheService _cache;
  final List<String> _ids = [];
  final Map<String, MenuItem> _catalog = {};
  bool _restored = false;

  /// Saved drinks, in the order they were added.
  List<MenuItem> get items => [for (final id in _ids) if (_catalog[id] != null) _catalog[id]!];
  int get count => items.length;
  bool get isEmpty => count == 0;
  bool contains(MenuItem item) => _ids.contains(item.id);

  /// Lowest listed price per drink, summed: what the card costs at minimum.
  double get estimatedFrom => items.fold(0, (sum, i) => sum + fromPrice(i));

  static double fromPrice(MenuItem i) =>
      [i.hotPrice, i.price16oz, i.price].whereType<double>().reduce((a, b) => a < b ? a : b);

  /// Loads saved ids once the menu is known; ids for drinks no longer on the menu are dropped.
  Future<void> restore(List<MenuItem> menu) async {
    for (final item in menu) {
      _catalog[item.id] = item;
    }
    if (_restored) return;
    _restored = true;
    await _cache.init();
    final saved = _cache.getCourtCardIds().where(_catalog.containsKey);
    for (final id in saved) {
      if (!_ids.contains(id)) _ids.add(id);
    }
    notifyListeners();
  }

  void toggle(MenuItem item) {
    _catalog[item.id] = item;
    if (!_ids.remove(item.id)) _ids.add(item.id);
    _persist();
  }

  void remove(MenuItem item) {
    if (_ids.remove(item.id)) _persist();
  }

  void clear() {
    _ids.clear();
    _persist();
  }

  void _persist() {
    notifyListeners();
    _cache.saveCourtCardIds(List.of(_ids));
  }
}
