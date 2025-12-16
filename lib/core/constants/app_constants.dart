class AppConstants {
  // App
  static const String appName = 'Flutter Shop';
  static const String appVersion = '1.0.0';
  
  // API (can be overridden by environment)
  static const String apiBaseUrl = 'https://api.yourshop.com';
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Image
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Cache
  static const Duration cacheExpiry = Duration(days: 7);
  static const String cacheVersion = 'v1';
  
  // Debounce
  static const Duration searchDebounce = Duration(milliseconds: 500);
  
  // Animation
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleUser = 'user';
}

