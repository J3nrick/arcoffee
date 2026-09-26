import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/menu_item.dart';

/// Network service communicating directly with Laravel API endpoints for Menu resources.
class MenuService {
  final ApiClient apiClient;

  MenuService({required this.apiClient});

  /// Fetch menu items from Laravel API (`GET /api/v1/menu?category=...&search=...`)
  Future<List<MenuItem>> fetchMenuItems({
    String? categorySlug,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{};
    if (categorySlug != null && categorySlug != 'all') {
      queryParams['category'] = categorySlug;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await apiClient.get(
      ApiEndpoints.menu,
      queryParameters: queryParams,
    );

    return _parseMenuList(response);
  }

  /// Fetch a single menu item by ID (`GET /api/v1/menu/{id}`)
  Future<MenuItem> fetchMenuItemById(String id) async {
    final response = await apiClient.get(ApiEndpoints.menuItem(id));

    if (response is Map<String, dynamic>) {
      final itemData = response.containsKey('data') ? response['data'] : response;
      return MenuItem.fromJson(Map<String, dynamic>.from(itemData));
    }
    throw Exception('Unexpected response format when fetching menu item $id');
  }

  /// Fetch featured & bestseller drinks (`GET /api/v1/menu/featured`)
  Future<List<MenuItem>> fetchFeaturedItems() async {
    final response = await apiClient.get(ApiEndpoints.menuFeatured);
    return _parseMenuList(response);
  }

  List<MenuItem> _parseMenuList(dynamic response) {
    List<dynamic> listData = [];

    if (response is Map<String, dynamic> && response.containsKey('data')) {
      listData = response['data'] as List<dynamic>;
    } else if (response is List<dynamic>) {
      listData = response;
    }

    return listData
        .map((json) => MenuItem.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}
