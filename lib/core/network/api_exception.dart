/// Unified Application Exception for Network and Server errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final bool isNetworkError;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.isNetworkError = false,
  });

  @override
  String toString() => 'ApiException(status: $statusCode, message: "$message")';

  factory ApiException.network({String message = 'Unable to connect to Arcoffee servers. Please check your internet connection.'}) {
    return ApiException(
      message: message,
      statusCode: null,
      isNetworkError: true,
    );
  }

  factory ApiException.server({
    int statusCode = 500,
    String message = 'Arcoffee server encountered an error. Please try again shortly.',
    dynamic data,
  }) {
    return ApiException(
      message: message,
      statusCode: statusCode,
      data: data,
      isNetworkError: false,
    );
  }
}
