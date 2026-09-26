import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import '../constants/app_colors.dart';

/// Pre-caching service to load high-priority visual assets before the first paint,
/// preventing layout shift and visual pop-in.
class ImagePrecacher {
  /// Priority images to preload on app startup
  static final List<String> priorityImageUrls = [
    // Brand & Hero assets
    'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800&q=80', // Coffee aesthetic
    'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&q=80', // Cafe & Community
    'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80', // Cold Brew & Espresso
    'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=800&q=80', // Matcha Green Drink
  ];

  static Future<void> precacheCoreAssets(BuildContext context) async {
    for (final url in priorityImageUrls) {
      try {
        await precacheImage(CachedNetworkImageProvider(url), context);
      } catch (_) {
        // Silently continue if network is slow or offline
      }
    }
  }
}

/// Robust Cupertino-styled Cached Network Image with smooth fade-in
/// and CupertinoActivityIndicator placeholder.
class ArcoffeeNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Color? placeholderColor;

  const ArcoffeeNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 12.0,
    this.placeholderColor,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildFallbackContainer();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 260),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: placeholderColor ?? AppColors.primaryBlue.withOpacity(0.06),
          child: const Center(
            child: CupertinoActivityIndicator(radius: 12),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallbackContainer(),
      ),
    );
  }

  Widget _buildFallbackContainer() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: placeholderColor ?? AppColors.primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Center(
        child: Icon(
          CupertinoIcons.photo,
          size: 24,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}
