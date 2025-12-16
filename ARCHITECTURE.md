# 🏗️ معماری پروژه

این سند توضیح کاملی از معماری و ساختار پروژه ارائه می‌دهد.

## 📐 الگوی معماری: Clean Architecture

پروژه از **Clean Architecture** استفاده می‌کند که شامل سه لایه اصلی است:

### 1. Presentation Layer (لایه نمایش)
- **مسئولیت**: نمایش UI و مدیریت state
- **اجزا**: Pages, Widgets, Providers
- **تکنولوژی**: Flutter, Riverpod

### 2. Domain Layer (لایه دامنه)
- **مسئولیت**: منطق کسب‌وکار
- **اجزا**: Entities, Use Cases
- **مستقل از**: Framework و Database

### 3. Data Layer (لایه داده)
- **مسئولیت**: دسترسی به داده‌ها
- **اجزا**: Repositories, Data Sources, Models
- **تکنولوژی**: Firebase, Dio, Hive

## 📁 ساختار پوشه‌ها

```
lib/
├── core/                      # هسته اصلی برنامه
│   ├── config/               # تنظیمات و پیکربندی
│   │   └── app_config.dart
│   ├── constants/            # ثابت‌ها
│   │   ├── app_constants.dart
│   │   └── app_strings.dart
│   ├── di/                   # Dependency Injection
│   │   └── injection.dart
│   ├── error/                # مدیریت خطا
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/              # شبکه و API
│   │   ├── dio_client.dart
│   │   └── network_info.dart
│   ├── router/               # مسیریابی
│   │   └── app_router.dart
│   ├── services/             # سرویس‌های اصلی
│   │   ├── firebase_service.dart
│   │   └── storage_service.dart
│   ├── theme/                # تم و استایل
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   └── utils/                # ابزارهای کمکی
│       ├── formatters.dart
│       ├── logger.dart
│       └── validators.dart
│
├── features/                  # ویژگی‌های اصلی (Feature-first)
│   ├── auth/                 # احراز هویت
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── register_page.dart
│   │       │   └── forgot_password_page.dart
│   │       └── providers/
│   │           └── auth_provider.dart
│   │
│   ├── admin/                # پنل مدیریت
│   │   └── presentation/
│   │       └── pages/
│   │           ├── admin_dashboard_page.dart
│   │           ├── product_management_page.dart
│   │           ├── category_management_page.dart
│   │           └── add_edit_product_page.dart
│   │
│   ├── product/              # محصولات
│   │   ├── data/
│   │   │   └── product_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── product_list_page.dart
│   │       │   └── product_detail_page.dart
│   │       └── providers/
│   │           └── product_provider.dart
│   │
│   ├── category/             # دسته‌بندی‌ها
│   │   ├── data/
│   │   │   └── category_repository.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── category_page.dart
│   │       └── providers/
│   │           └── category_provider.dart
│   │
│   ├── home/                 # صفحه اصلی
│   │   └── presentation/
│   │       └── pages/
│   │           └── home_page.dart
│   │
│   └── order/                # سفارشات
│       └── data/
│           └── order_repository.dart
│
├── shared/                    # اجزای مشترک
│   ├── models/               # مدل‌های داده
│   │   ├── user_model.dart
│   │   ├── product_model.dart
│   │   ├── category_model.dart
│   │   ├── order_model.dart
│   │   └── filter_model.dart
│   ├── providers/            # Provider های مشترک
│   │   └── theme_provider.dart
│   └── widgets/              # ویجت‌های مشترک
│       ├── custom_text_field.dart
│       ├── loading_indicator.dart
│       ├── empty_state.dart
│       ├── error_widget.dart
│       ├── product_card.dart
│       └── category_chip.dart
│
└── main.dart                  # نقطه شروع برنامه
```

## 🔄 جریان داده (Data Flow)

```
UI (Page/Widget)
    ↓
Provider (Riverpod)
    ↓
Repository
    ↓
Data Source (Firebase/API)
    ↓
Model
    ↓
State Update
    ↓
UI Re-render
```

## 🎯 اصول طراحی (SOLID)

### 1. Single Responsibility Principle (SRP)
هر کلاس فقط یک مسئولیت دارد:
- `ProductRepository`: فقط مدیریت داده محصولات
- `AuthProvider`: فقط مدیریت state احراز هویت

### 2. Open/Closed Principle (OCP)
کلاس‌ها برای توسعه باز و برای تغییر بسته هستند:
- استفاده از Abstract Classes و Interfaces

### 3. Liskov Substitution Principle (LSP)
زیرکلاس‌ها باید جایگزین والد خود شوند:
- Repository implementations

### 4. Interface Segregation Principle (ISP)
Interface های کوچک و مشخص:
- جدا کردن responsibilities در interfaces

### 5. Dependency Inversion Principle (DIP)
وابستگی به abstractions نه concrete classes:
- استفاده از Dependency Injection (get_it)

## 🔧 State Management: Riverpod

### چرا Riverpod؟
- ✅ Type-safe
- ✅ Compile-time safety
- ✅ بدون BuildContext
- ✅ Testing راحت
- ✅ Hot-reload سازگار

### انواع Provider ها

#### 1. Provider
برای مقادیر ثابت یا singleton:
```dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return getIt<AuthRepository>();
});
```

#### 2. StateNotifierProvider
برای state های قابل تغییر:
```dart
final authControllerProvider = 
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});
```

#### 3. FutureProvider
برای عملیات async:
```dart
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final result = await getIt<AuthRepository>().getCurrentUser();
  return result.fold((failure) => null, (user) => user);
});
```

#### 4. StreamProvider
برای stream ها:
```dart
final authStateProvider = StreamProvider<User?>((ref) {
  return getIt<AuthRepository>().authStateChanges;
});
```

## 📦 Dependency Injection: get_it

### تعریف Dependencies
```dart
Future<void> setupDependencyInjection() async {
  // Services
  getIt.registerLazySingleton<FirebaseService>(() => FirebaseService());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      firebaseService: getIt<FirebaseService>(),
      storageService: getIt<StorageService>(),
    ),
  );
}
```

### استفاده
```dart
final authRepository = getIt<AuthRepository>();
```

## 🗄️ Data Models: Freezed

### چرا Freezed؟
- ✅ Immutability
- ✅ Code generation
- ✅ copyWith method
- ✅ Equality comparison
- ✅ Serialization support

### مثال
```dart
@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();
  
  const factory ProductModel({
    required String id,
    required String name,
    required double price,
  }) = _ProductModel;
  
  factory ProductModel.fromJson(Map<String, dynamic> json) => 
      _$ProductModelFromJson(json);
}
```

## 🔀 Routing: go_router

### مزایا
- ✅ Declarative routing
- ✅ Deep linking support
- ✅ Route guards
- ✅ Nested navigation

### مثال
```dart
GoRoute(
  path: '/products/:id',
  name: 'product-detail',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProductDetailPage(productId: id);
  },
),
```

## 🎨 Theming

### ساختار تم
```dart
class AppTheme {
  static ThemeData lightTheme() { ... }
  static ThemeData darkTheme() { ... }
}
```

### استفاده
```dart
MaterialApp(
  theme: AppTheme.lightTheme(),
  darkTheme: AppTheme.darkTheme(),
  themeMode: themeMode,
)
```

## 🔐 Security

### 1. Firebase Security Rules
- Authentication required
- Role-based access control
- Data validation

### 2. Environment Configuration
- جداسازی dev/staging/prod
- API keys در environment variables

### 3. Error Handling
- مدیریت خطاهای شبکه
- مدیریت خطاهای Firebase
- User-friendly error messages

## 📊 Performance Optimization

### 1. Lazy Loading
```dart
getIt.registerLazySingleton<AuthRepository>(() => ...);
```

### 2. Image Caching
```dart
CachedNetworkImage(...)
```

### 3. Pagination
```dart
Future<void> loadProducts({DocumentSnapshot? lastDocument}) async {
  // Load next page
}
```

### 4. Debouncing
```dart
Timer? _debounce;
_debounce?.cancel();
_debounce = Timer(Duration(milliseconds: 500), () {
  // Search
});
```

## 🧪 Testing Strategy

### 1. Unit Tests
- Repository tests
- Use case tests
- Utility function tests

### 2. Widget Tests
- Widget rendering
- User interactions
- State changes

### 3. Integration Tests
- End-to-end flows
- API integration
- Database operations

## 📈 Scalability

### افزودن Feature جدید

1. ایجاد پوشه در `features/`
2. پیاده‌سازی data layer (repository)
3. ایجاد models
4. پیاده‌سازی presentation layer (pages, providers)
5. افزودن routes
6. نوشتن تست‌ها

### مثال: افزودن Cart Feature
```
features/cart/
├── data/
│   └── cart_repository.dart
├── domain/
│   └── entities/
│       └── cart_item.dart
└── presentation/
    ├── pages/
    │   └── cart_page.dart
    └── providers/
        └── cart_provider.dart
```

## 🔄 CI/CD Pipeline

### مراحل
1. **Code Quality**: Linting, formatting
2. **Testing**: Unit, Widget, Integration tests
3. **Build**: Android AAB, iOS IPA
4. **Deploy**: Firebase App Distribution
5. **Release**: Play Store, App Store

## 📝 Best Practices

1. ✅ همیشه از const constructors استفاده کنید
2. ✅ از named parameters استفاده کنید
3. ✅ Error handling جامع
4. ✅ Logging مناسب
5. ✅ کد خوانا و مستند
6. ✅ DRY (Don't Repeat Yourself)
7. ✅ YAGNI (You Aren't Gonna Need It)
8. ✅ KISS (Keep It Simple, Stupid)

## 🎓 منابع یادگیری

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

---

**این معماری قابل توسعه، قابل تست و قابل نگهداری است! 🚀**

