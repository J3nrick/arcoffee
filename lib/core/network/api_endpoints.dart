/// Canonical Laravel REST API Endpoint routes for Arcoffee.
abstract class ApiEndpoints {
  // Menu Endpoints
  static const String menu = '/api/v1/menu';
  static const String menuFeatured = '/api/v1/menu/featured';
  static const String menuCategories = '/api/v1/menu/categories';
  static String menuItem(String id) => '/api/v1/menu/$id';

  // Store & Venue Endpoints
  static const String storeInfo = '/api/v1/store';
  static const String storeStatus = '/api/v1/store/status';

  // Community / Gallery Endpoints
  static const String gallery = '/api/v1/gallery';
  static String galleryLike(String id) => '/api/v1/gallery/$id/like';
}
