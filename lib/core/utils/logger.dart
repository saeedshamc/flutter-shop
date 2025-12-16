import 'package:logger/logger.dart';
import '../config/app_config.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );
  
  static void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.instance.enableLogging) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }
  
  static void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.instance.enableLogging) {
      _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }
  
  static void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.instance.enableLogging) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }
  
  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
  
  static void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

