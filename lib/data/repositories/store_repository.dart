import 'dart:async';
import '../../core/network/app_config.dart';
import '../models/store_info.dart';
import '../services/store_service.dart';

/// Abstract contract for store data.
abstract class StoreRepository {
  Future<StoreInfo> getStoreInfo();
  Future<bool> isStoreOpenCurrently();
}

/// Store repository supporting live Laravel API or fallback local metadata.
class AppStoreRepository implements StoreRepository {
  final StoreService? storeService;

  AppStoreRepository({this.storeService});

  static const StoreInfo _defaultStore = StoreInfo(
    name: 'Arcoffee',
    slogan: "It's always been ours.",
    venue: 'The Pickleground PH',
    address: 'Advincula Ave, boundary of Kawit and Noveleta',
    province: 'Cavite, Philippines',
    weekdayHours: 'Mon – Thu: 2:00 PM – 10:00 PM',
    weekendHours: 'Fri – Sun: 24 Hours Non-Stop',
    phone: '+63 917 552 2726',
    email: 'contact@arcoffee.ph',
    instagram: '@arcoffee.ph',
    facebook: 'facebook.com/arcoffeeph',
    courtAmenities: [
      'Regulation Pickleball Courts',
      '24-Hour Weekend Games',
      'Courtside Viewing Deck',
      'High-Speed Wi-Fi',
      'Device Charging Hubs',
      'Pet Friendly Patio',
      'Dedicated Free Parking',
      'Post-Game Recovery Drinks',
    ],
    isOpen24HoursWeekend: true,
  );

  @override
  Future<StoreInfo> getStoreInfo() async {
    if (AppConfig.useLiveApi && storeService != null) {
      return await storeService!.fetchStoreInfo();
    }
    await Future.delayed(Duration(milliseconds: AppConfig.mockDelayMs));
    return _defaultStore;
  }

  @override
  Future<bool> isStoreOpenCurrently() async {
    if (AppConfig.useLiveApi && storeService != null) {
      return await storeService!.checkStoreStatus();
    }

    final now = DateTime.now();
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    final hour = now.hour;

    // Friday (5), Saturday (6), Sunday (7) are 24 hours
    if (weekday >= DateTime.friday && weekday <= DateTime.sunday) {
      return true;
    }

    // Mon - Thu: 2:00 PM (14) to 10:00 PM (22)
    return hour >= 14 && hour < 22;
  }
}

typedef MockStoreRepository = AppStoreRepository;
