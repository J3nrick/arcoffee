import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import '../design/app_colors.dart';

/// Pre-caching service to load high-priority visual assets before the first paint,
/// preventing layout shift and visual pop-in.
class ImagePrecacher {
  /// Priority images to preload on app startup
  static final List<String> priorityImageUrls = [
    // Hero & Editorial Assets
    'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=1200&q=85', // Hero Iced Coffee on Outdoor Surface
    'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=1000&q=85', // Milo Overload / Signature Malt Coffee
    'https://images.unsplash.com/photo-1576092768241-dec231879fc3?w=800&q=80',  // Haw-Haw Matcha
    'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800&q=80',  // Cold Brew & Espresso Shot
    'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=800&q=80',  // Community Cafe & Court Atmosphere
    'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=800&q=80',  // Night Coffee Session
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
        fadeInDuration: const Duration(milliseconds: 250),
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: placeholderColor ?? AppColors.deepBlue.withOpacity(0.06),
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
        color: placeholderColor ?? AppColors.deepBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Center(
        child: Icon(
          CupertinoIcons.photo,
          size: 24,
          color: AppColors.textTertiaryDay,
        ),
      ),
    );
  }
}
