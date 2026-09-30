import 'package:flutter/foundation.dart';
import '../models/tray_item.dart';

/// Centralized state manager for the player's Courtside Tray and Court Delivery details.
class OrderTrayService extends ChangeNotifier {
  static final OrderTrayService instance = OrderTrayService._internal();

  OrderTrayService._internal();

  final List<TrayItem> _items = [];
  bool _isCourtDelivery = true;
  String _courtNumber = '1';
  String _playerNote = '';

  List<TrayItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => _isCourtDelivery ? 0.0 : 0.0; // Complimentary court delivery
  double get totalAmount => subtotal + deliveryFee;

  bool get isCourtDelivery => _isCourtDelivery;
  String get courtNumber => _courtNumber;
  String get playerNote => _playerNote;

  void setCourtDelivery(bool value) {
    _isCourtDelivery = value;
    notifyListeners();
  }

  void setCourtNumber(String court) {
    _courtNumber = court;
    notifyListeners();
  }

  void setPlayerNote(String note) {
    _playerNote = note;
    notifyListeners();
  }

  void addItem(TrayItem newItem) {
    // Check if an identical customized item exists
    final index = _items.indexWhere((it) =>
        it.menuItem.id == newItem.menuItem.id &&
        it.size == newItem.size &&
        it.iceLevel == newItem.iceLevel &&
        it.sweetness == newItem.sweetness &&
        listEquals(it.addons, newItem.addons));

    if (index >= 0) {
      _items[index].quantity += newItem.quantity;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void updateQuantity(String id, int delta) {
    final index = _items.indexWhere((it) => it.id == id);
    if (index >= 0) {
      final updated = _items[index].quantity + delta;
      if (updated <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = updated;
      }
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((it) => it.id == id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _playerNote = '';
    notifyListeners();
  }
}
