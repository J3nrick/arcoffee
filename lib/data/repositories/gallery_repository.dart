import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/app_config.dart';
import '../models/gallery_item.dart';
import '../services/gallery_service.dart';

abstract class GalleryRepository {
  Future<List<GalleryItem>> getGalleryItems();
  Future<bool> toggleLike(String id);
}

class AppGalleryRepository implements GalleryRepository {
  final GalleryService? galleryService;

  AppGalleryRepository({this.galleryService});

  static final List<GalleryItem> _mockItems = [
    const GalleryItem(
      id: 'g1',
      title: 'Midnight Rallies & Espresso',
      category: 'Court Action',
      subtitle: 'Full court lighting during our 24-hour weekend session at The Pickleground.',
      icon: CupertinoIcons.sportscourt_fill,
      primaryColor: AppColors.primaryBlue,
      secondaryColor: AppColors.accentOrange,
      heightRatio: 1.25,
      likesCount: '482',
      timestamp: 'Friday Night Run',
    ),
    const GalleryItem(
      id: 'g2',
      title: 'Haw-Haw Matcha Drift',
      category: 'Drink Spotlight',
      subtitle: 'The original nostalgic fusion. Freshly poured right before a tournament match.',
      icon: CupertinoIcons.sparkles,
      primaryColor: AppColors.matchaGreen,
      secondaryColor: AppColors.courtOrange,
      heightRatio: 1.0,
      likesCount: '629',
      timestamp: 'Just now',
    ),
    const GalleryItem(
      id: 'g3',
      title: 'Courtside Community Chill',
      category: 'Community',
      subtitle: 'Friends cooling off with Lychee Sparklers and Milo Overload after game 3.',
      icon: CupertinoIcons.person_3_fill,
      primaryColor: Color(0xFF1E3A8A),
      secondaryColor: Color(0xFF60A5FA),
      heightRatio: 1.35,
      likesCount: '315',
      timestamp: 'Saturday Afternoon',
    ),
    const GalleryItem(
      id: 'g4',
      title: 'Zero Heat Sparklers',
      category: 'Refreshment',
      subtitle: 'Lemon Yuzu and Green Apple Fizz cooling down the midday Cavite heat.',
      icon: CupertinoIcons.burst_fill,
      primaryColor: AppColors.sodaBlue,
      secondaryColor: Color(0xFFFFB300),
      heightRatio: 1.1,
      likesCount: '271',
      timestamp: '2h ago',
    ),
    const GalleryItem(
      id: 'g5',
      title: 'The Pickleground Arena',
      category: 'Vibe & Aesthetic',
      subtitle: 'Modern sports park vibe nestled between Kawit and Noveleta.',
      icon: CupertinoIcons.flag_fill,
      primaryColor: Color(0xFF2E7D32),
      secondaryColor: AppColors.accentOrange,
      heightRatio: 1.2,
      likesCount: '540',
      timestamp: 'Weekend Special',
    ),
    const GalleryItem(
      id: 'g6',
      title: 'Barista Craft at Dawn',
      category: 'Craftsmanship',
      subtitle: 'Pours that never stop when weekend tournaments go round-the-clock.',
      icon: CupertinoIcons.drop_fill,
      primaryColor: AppColors.warmCoffee,
      secondaryColor: AppColors.badgeHighlight,
      heightRatio: 1.05,
      likesCount: '394',
      timestamp: 'Dawn Shift',
    ),
  ];

  @override
  Future<List<GalleryItem>> getGalleryItems() async {
    if (AppConfig.useLiveApi && galleryService != null) {
      return await galleryService!.fetchGalleryItems();
    }

    if (AppConfig.simulateApiFailure) {
      throw const ApiException(
        message: 'Unable to reach community feed. Network error occurred.',
        statusCode: 503,
      );
    }

    await Future.delayed(Duration(milliseconds: AppConfig.mockDelayMs));
    return List.unmodifiable(_mockItems);
  }

  @override
  Future<bool> toggleLike(String id) async {
    if (AppConfig.useLiveApi && galleryService != null) {
      return await galleryService!.toggleLike(id);
    }
    return true;
  }
}

typedef MockGalleryRepository = AppGalleryRepository;
