/// Global Application Environment & Configuration.
/// Handles switching between Mock Data (standalone testing) and Live Laravel API.
class AppConfig {
  /// Toggle this boolean or pass via `--dart-define=USE_LIVE_API=true`
  static bool useLiveApi = const bool.fromEnvironment('USE_LIVE_API', defaultValue: false);

  /// Simulated network delay for mock mode (in milliseconds)
  static int mockDelayMs = 120;

  /// Debug flag to simulate API failures and test the Apple HIG retry dialog
  static bool simulateApiFailure = false;

  /// Laravel REST API Base URL
  static String apiBaseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.arcoffee.ph',
  );

  /// API Version Prefix
  static const String apiVersion = '/api/v1';

  /// Connect Timeout Duration
  static const Duration connectTimeout = Duration(seconds: 10);

  /// Receive Timeout Duration
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Helper to toggle between live and mock
  static void setLiveApi(bool enabled) {
    useLiveApi = enabled;
  }
}
