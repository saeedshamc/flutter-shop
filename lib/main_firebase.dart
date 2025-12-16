import 'package:firebase_core/firebase_core.dart';
import 'core/di/injection.dart';
import 'core/services/firebase_service.dart';
import 'core/services/storage_service.dart';

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    await setupDependencyInjection();
    await getIt<StorageService>().initialize();
    await getIt<FirebaseService>().initialize();
  } catch (e) {
    // Firebase not configured, continue without it
    rethrow;
  }
}

