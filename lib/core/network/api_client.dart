import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart' as dio_pkg;
import 'package:http/http.dart' as http;
import 'api_exception.dart';
import 'app_config.dart';

/// Production-ready HTTP network client tailored for PHP Laravel REST backends.
/// Encapsulates authentication headers, timeouts, error interception, and JSON parsing.
class ApiClient {
  final String baseUrl;
  final dio_pkg.Dio? _dio;
  final http.Client? _httpClient;

  /// Optional Dio instance accessor for advanced streaming/interceptors.
  dio_pkg.Dio? get dio => _dio;

  ApiClient({
    String? baseUrl,
    dio_pkg.Dio? dio,
    http.Client? httpClient,
  })  : baseUrl = baseUrl ?? AppConfig.apiBaseUrl,
        _dio = dio,
        _httpClient = httpClient;

  Map<String, String> get _defaultHeaders => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'X-Client-Platform': 'Flutter-Web-Cupertino',
        'X-App-Version': '1.0.0',
      };

  /// Perform a GET request to the Laravel API.
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    // If debug simulation is enabled, throw an ApiException
    if (AppConfig.simulateApiFailure) {
      throw const ApiException(
        message: 'Simulated API failure. Testing Apple HIG retry alert.',
        statusCode: 503,
      );
    }

    try {
      final uri = _buildUri(path, queryParameters);
      final mergedHeaders = {..._defaultHeaders, if (headers != null) ...headers};

      final client = _httpClient ?? http.Client();
      final response = await client
          .get(uri, headers: mergedHeaders)
          .timeout(AppConfig.connectTimeout);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw ApiException.network(message: 'Connection failed: ${e.message}');
    } on TimeoutException {
      throw ApiException.network(message: 'Request to Arcoffee servers timed out. Please try again.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException.server(message: e.toString());
    }
  }

  /// Perform a POST request to the Laravel API.
  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(path, queryParameters);
      final mergedHeaders = {..._defaultHeaders, if (headers != null) ...headers};

      final client = _httpClient ?? http.Client();
      final response = await client
          .post(
            uri,
            headers: mergedHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(AppConfig.connectTimeout);

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw ApiException.network(message: 'Connection failed: ${e.message}');
    } on TimeoutException {
      throw ApiException.network(message: 'Request timed out. Please retry.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException.server(message: e.toString());
    }
  }

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final cleanBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final fullUrl = '$cleanBase$cleanPath';

    final uri = Uri.parse(fullUrl);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final stringParams = queryParameters.map((k, v) => MapEntry(k, v.toString()));
      return uri.replace(queryParameters: stringParams);
    }
    return uri;
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic decoded;

    try {
      if (response.body.isNotEmpty) {
        decoded = jsonDecode(response.body);
      }
    } catch (_) {
      decoded = response.body;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    } else if (statusCode == 404) {
      throw ApiException(
        statusCode: 404,
        message: 'The requested menu item or resource was not found.',
        data: decoded,
      );
    } else if (statusCode == 422) {
      final message = decoded is Map && decoded['message'] != null
          ? decoded['message']
          : 'Validation failed on the server.';
      throw ApiException(
        statusCode: 422,
        message: message.toString(),
        data: decoded,
      );
    } else {
      final message = decoded is Map && decoded['message'] != null
          ? decoded['message']
          : 'Server returned error ($statusCode).';
      throw ApiException.server(
        statusCode: statusCode,
        message: message.toString(),
        data: decoded,
      );
    }
  }
}
