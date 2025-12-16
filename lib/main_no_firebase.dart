// Fallback when Firebase is not available
import 'core/di/injection.dart';

Future<void> initializeFirebase() async {
  // Firebase not available, skip initialization
  // Still setup basic dependency injection
  try {
    await setupDependencyInjection();
  } catch (e) {
    // Continue without DI if it fails
  }
}

