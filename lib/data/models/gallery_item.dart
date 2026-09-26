import 'package:flutter/cupertino.dart';
import '../../core/constants/app_colors.dart';

/// Community & lifestyle item for the masonry gallery grid.
class GalleryItem {
  final String id;
  final String title;
  final String category;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final double heightRatio;
  final String likesCount;
  final String timestamp;

  const GalleryItem({
    required this.id,
    required this.title,
    required this.category,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    this.heightRatio = 1.0,
    this.likesCount = '120',
    this.timestamp = '2h ago',
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'Community',
      subtitle: json['subtitle'] ?? '',
      icon: CupertinoIcons.photo,
      primaryColor: AppColors.primaryBlue,
      secondaryColor: AppColors.accentOrange,
      heightRatio: (json['height_ratio'] as num?)?.toDouble() ?? 1.0,
      likesCount: json['likes_count'] ?? '99',
      timestamp: json['timestamp'] ?? 'Today',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'subtitle': subtitle,
      'height_ratio': heightRatio,
      'likes_count': likesCount,
      'timestamp': timestamp,
    };
  }
}
