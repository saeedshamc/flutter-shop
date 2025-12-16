import 'package:hive_flutter/hive_flutter.dart';
import '../utils/logger.dart';

class StorageService {
  // Singleton Pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
  
  // Box Names
  static const String _authBox = 'auth_box';
  static const String _settingsBox = 'settings_box';
  static const String _cacheBox = 'cache_box';
  
  // Boxes
  late Box<dynamic> _authBoxInstance;
  late Box<dynamic> _settingsBoxInstance;
  late Box<dynamic> _cacheBoxInstance;
  
  // Initialize Hive
  Future<void> initialize() async {
    try {
      await Hive.initFlutter();
      
      _authBoxInstance = await Hive.openBox(_authBox);
      _settingsBoxInstance = await Hive.openBox(_settingsBox);
      _cacheBoxInstance = await Hive.openBox(_cacheBox);
      
      AppLogger.info('Storage Service initialized');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize Storage Service', e, stackTrace);
      rethrow;
    }
  }
  
  // Auth Box Methods
  Future<void> saveAuthToken(String token) async {
    await _authBoxInstance.put('token', token);
  }
  
  String? getAuthToken() {
    return _authBoxInstance.get('token');
  }
  
  Future<void> clearAuthToken() async {
    await _authBoxInstance.delete('token');
  }
  
  // Settings Box Methods
  Future<void> setThemeMode(String mode) async {
    await _settingsBoxInstance.put('theme_mode', mode);
  }
  
  String getThemeMode() {
    return _settingsBoxInstance.get('theme_mode', defaultValue: 'system');
  }
  
  Future<void> setLanguage(String language) async {
    await _settingsBoxInstance.put('language', language);
  }
  
  String getLanguage() {
    return _settingsBoxInstance.get('language', defaultValue: 'fa');
  }
  
  // Cache Box Methods
  Future<void> cacheData(String key, dynamic value) async {
    await _cacheBoxInstance.put(key, value);
  }
  
  dynamic getCachedData(String key) {
    return _cacheBoxInstance.get(key);
  }
  
  Future<void> clearCache() async {
    await _cacheBoxInstance.clear();
  }
  
  // Clear All Data
  Future<void> clearAll() async {
    await _authBoxInstance.clear();
    await _settingsBoxInstance.clear();
    await _cacheBoxInstance.clear();
  }
}

