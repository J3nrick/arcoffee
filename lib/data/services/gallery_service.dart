import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/gallery_item.dart';

/// Network service communicating with Laravel API endpoints for Community Gallery posts.
class GalleryService {
  final ApiClient apiClient;

  GalleryService({required this.apiClient});

  /// Fetch gallery items (`GET /api/v1/gallery`)
  Future<List<GalleryItem>> fetchGalleryItems() async {
    final response = await apiClient.get(ApiEndpoints.gallery);

    List<dynamic> listData = [];
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      listData = response['data'] as List<dynamic>;
    } else if (response is List<dynamic>) {
      listData = response;
    }

    return listData
        .map((json) => GalleryItem.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  /// Toggle like counter on a gallery item (`POST /api/v1/gallery/{id}/like`)
  Future<bool> toggleLike(String id) async {
    final response = await apiClient.post(ApiEndpoints.galleryLike(id));
    if (response is Map<String, dynamic>) {
      return response['liked'] == true;
    }
    return true;
  }
}
