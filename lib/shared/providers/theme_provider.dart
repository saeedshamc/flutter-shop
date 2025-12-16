import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/storage_service.dart';
import '../../core/di/injection.dart';

// Theme Mode State
enum AppThemeMode { light, dark, system }

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final StorageService _storageService;
  
  ThemeModeNotifier(this._storageService) : super(ThemeMode.system) {
    _loadThemeMode();
  }
  
  void _loadThemeMode() {
    final savedMode = _storageService.getThemeMode();
    switch (savedMode) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
    }
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _storageService.setThemeMode(mode.name);
  }
  
  void toggleTheme() {
    if (state == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(getIt<StorageService>());
});

