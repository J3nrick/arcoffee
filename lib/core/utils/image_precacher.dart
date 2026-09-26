import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import '../design/app_colors.dart';

/// Pre-caching service to load high-priority visual assets before the first paint,
/// preventing layout shift and visual pop-in.
class ImagePrecacher {
  /// Priority local asset images to preload on app startup
  static const List<String> priorityAssetPaths = [
    'assets/images/milo_overload_court.png',
    'assets/images/mango_americano_counter.jpg',
    'assets/images/court_arena_drink.jpg',
    'assets/images/community_milo_jersey.jpg',
    'assets/images/lychee_soda_chat_paddle.jpg',
    'assets/images/green_apple_court_line.jpg',
    'assets/images/portafilter_tamp.jpg',
    'assets/images/latte_pull_portrait.png',
    'assets/images/spanish_latte_mascot.jpg',
    'assets/images/matcha_pour.png',
    'assets/images/soda_series_studio.png',
  ];

  static Future<void> precacheCoreAssets(BuildContext context) async {
    for (final assetPath in priorityAssetPaths) {
      try {
        await precacheImage(AssetImage(assetPath), context);
      } catch (_) {
        // Silently continue if asset loading is interrupted
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
