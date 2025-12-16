enum Environment { dev, staging, prod }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String apiKey;
  final bool enableLogging;
  final bool enableCrashlytics;
  
  AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.apiKey,
    required this.enableLogging,
    required this.enableCrashlytics,
  });
  
  static AppConfig? _instance;
  
  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig not initialized. Call initialize() first.');
    }
    return _instance!;
  }
  
  static void initialize({
    required Environment environment,
    String? apiBaseUrl,
    String? apiKey,
  }) {
    _instance = AppConfig(
      environment: environment,
      apiBaseUrl: apiBaseUrl ?? _getDefaultApiUrl(environment),
      apiKey: apiKey ?? '',
      enableLogging: environment != Environment.prod,
      enableCrashlytics: environment == Environment.prod,
    );
  }
  
  static String _getDefaultApiUrl(Environment environment) {
    switch (environment) {
      case Environment.dev:
        return 'https://dev-api.yourshop.com';
      case Environment.staging:
        return 'https://staging-api.yourshop.com';
      case Environment.prod:
        return 'https://api.yourshop.com';
    }
  }
  
  bool get isDevelopment => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProduction => environment == Environment.prod;
}

