import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/product/data/product_repository.dart';
import '../../features/category/data/category_repository.dart';
import '../../features/order/data/order_repository.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Core Services
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<DioClient>(() => DioClient());
  
  // Network
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseService: getIt<FirebaseService>(),
      storageService: getIt<StorageService>(),
    ),
  );
  
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      firebaseService: getIt<FirebaseService>(),
    ),
  );
  
  getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      firebaseService: getIt<FirebaseService>(),
    ),
  );
  
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      firebaseService: getIt<FirebaseService>(),
    ),
  );
}

