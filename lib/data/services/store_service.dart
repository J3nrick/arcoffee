import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/store_info.dart';

/// Network service communicating with Laravel API endpoints for Store and Schedule metadata.
class StoreService {
  final ApiClient apiClient;

  StoreService({required this.apiClient});

  /// Fetch store operating details (`GET /api/v1/store`)
  Future<StoreInfo> fetchStoreInfo() async {
    final response = await apiClient.get(ApiEndpoints.storeInfo);

    if (response is Map<String, dynamic>) {
      final data = response.containsKey('data') ? response['data'] : response;
      return StoreInfo.fromJson(Map<String, dynamic>.from(data));
    }
    throw Exception('Unexpected response format when fetching store info');
  }

  /// Check whether the store is open in real-time (`GET /api/v1/store/status`)
  Future<bool> checkStoreStatus() async {
    final response = await apiClient.get(ApiEndpoints.storeStatus);
    if (response is Map<String, dynamic>) {
      final data = response.containsKey('data') ? response['data'] : response;
      return data['is_open'] == true;
    }
    return true;
  }
}
