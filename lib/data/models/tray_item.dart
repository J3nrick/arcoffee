import 'menu_item.dart';

/// Single customized beverage entry in the player's Courtside Tray.
class TrayItem {
  final String id;
  final MenuItem menuItem;
  final String size;
  final String iceLevel;
  final String sweetness;
  final List<String> addons;
  final double unitPrice;
  int quantity;

  TrayItem({
    required this.id,
    required this.menuItem,
    required this.size,
    required this.iceLevel,
    required this.sweetness,
    required this.addons,
    required this.unitPrice,
    this.quantity = 1,
  });

  double get totalPrice => unitPrice * quantity;

  String get customizationSummary {
    final parts = [size, iceLevel, sweetness];
    if (addons.isNotEmpty) {
      parts.add('+ ${addons.join(', ')}');
    }
    return parts.join(' • ');
  }
}
