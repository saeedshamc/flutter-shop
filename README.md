# 🛍️ Flutter Shop App - Commercial E-Commerce Application

یک اپلیکیشن فروشگاهی کاملاً تجاری، مقیاس‌پذیر و قابل انتشار برای Android و iOS

## ✨ ویژگی‌های اصلی

### 🔐 احراز هویت و امنیت
- ثبت‌نام و ورود با ایمیل/رمز عبور
- ورود با Google
- بازیابی رمز عبور
- مدیریت JWT Token
- Role-Based Access Control (Admin/User)

### 👨‍💼 پنل مدیریت (Admin Panel)
- داشبورد آماری
- مدیریت محصولات (افزودن، ویرایش، حذف)
- مدیریت دسته‌بندی‌ها
- مدیریت موجودی
- مدیریت کاربران
- آپلود تصویر

### 🛒 امکانات کاربر
- صفحه اصلی با اسلایدر و دسته‌بندی‌ها
- لیست محصولات با Pagination
- جستجوی Real-Time
- فیلتر پیشرفته (قیمت، برند، دسته‌بندی)
- مرتب‌سازی (ارزان‌ترین، گران‌ترین، جدیدترین)
- صفحه جزئیات محصول
- سبد خرید (آماده توسعه)

### 🎨 UI/UX
- طراحی Material 3
- Dark/Light Mode
- انیمیشن‌های نرم
- Skeleton Loader
- Empty & Error States
- Responsive Design
- پشتیبانی از RTL

## 🏗️ معماری

این پروژه از **Clean Architecture** استفاده می‌کند:

```
lib/
├── core/
│   ├── config/           # تنظیمات و Environment
│   ├── constants/        # ثابت‌ها
│   ├── theme/           # تم‌ها و استایل‌ها
│   ├── utils/           # ابزارهای کمکی
│   ├── error/           # مدیریت خطا
│   └── network/         # شبکه و API
├── features/
│   ├── auth/
│   │   ├── data/        # Data Sources & Repositories
│   │   ├── domain/      # Entities & Use Cases
│   │   └── presentation/ # UI & State Management
│   ├── admin/
│   ├── product/
│   ├── category/
│   └── user/
├── shared/
│   ├── models/          # مدل‌های مشترک
│   ├── widgets/         # ویجت‌های مشترک
│   └── providers/       # Provider های مشترک
└── main.dart
```

## 🛠️ تکنولوژی‌ها

### Core
- **Flutter** 3.2+
- **Dart** 3.2+

### State Management
- **Riverpod** 2.5+ - مدیریت state
- **Riverpod Generator** - Code generation

### Dependency Injection
- **get_it** - Service Locator
- **injectable** - DI Code generation

### Navigation
- **go_router** - Routing و Navigation

### Backend & Database
- **Firebase Auth** - احراز هویت
- **Cloud Firestore** - دیتابیس
- **Firebase Storage** - ذخیره فایل‌ها
- **Firebase Crashlytics** - گزارش خطا
- **Firebase Analytics** - تحلیل رفتار کاربر

### Networking
- **Dio** - HTTP Client
- **Retrofit** - REST API Client
- **Pretty Dio Logger** - لاگ درخواست‌ها

### Local Storage
- **Hive** - Local Database
- **SharedPreferences** - Key-Value Storage

### UI & Images
- **cached_network_image** - Cache تصاویر
- **shimmer** - Loading Skeleton
- **lottie** - انیمیشن‌های Vector
- **image_picker** - انتخاب تصویر

### Utils
- **freezed** - Immutable Classes
- **json_serializable** - JSON Serialization
- **dartz** - Functional Programming
- **logger** - لاگ‌گیری
- **intl** - چندزبانه‌سازی

## 📦 نصب و راه‌اندازی

### پیش‌نیازها
```bash
Flutter SDK 3.2.0+
Dart SDK 3.2.0+
Android Studio / Xcode
Firebase Account
```

### مراحل نصب

1. **Clone کردن پروژه**
```bash
git clone <repository-url>
cd flutter-app
```

2. **نصب وابستگی‌ها**
```bash
flutter pub get
```

3. **تنظیم Firebase**
- پروژه Firebase ایجاد کنید
- فایل `google-services.json` را در `android/app/` قرار دهید
- فایل `GoogleService-Info.plist` را در `ios/Runner/` قرار دهید
- دستور زیر را اجرا کنید:
```bash
flutterfire configure
```

4. **Generate کردن کدهای خودکار**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. **اجرای پروژه**
```bash
# Development
flutter run --dart-define=ENVIRONMENT=dev

# Production
flutter run --dart-define=ENVIRONMENT=prod
```

## 🔧 Environment Configuration

پروژه از سه محیط پشتیبانی می‌کند:

- **Development** (dev)
- **Staging** (staging)  
- **Production** (prod)

فایل `.env` ایجاد کنید:

```env
API_BASE_URL=https://your-api.com
API_KEY=your_api_key
```

## 🏃‍♂️ اجرا

### Development
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

### Production
```bash
flutter run --flavor prod -t lib/main_prod.dart
```

## 🧪 تست

```bash
# Unit Tests
flutter test

# Widget Tests
flutter test test/widget_test

# Integration Tests
flutter test integration_test
```

## 📱 Build کردن

### Android (AAB)
```bash
flutter build appbundle --release
```

### Android (APK)
```bash
flutter build apk --release --split-per-abi
```

### iOS
```bash
flutter build ipa --release
```

## 📊 ساختار دیتابیس (Firestore)

### Collections

#### Users
```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "role": "admin|user",
  "photoUrl": "string?",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### Products
```json
{
  "id": "string",
  "name": "string",
  "brand": "string",
  "description": "string",
  "price": "number",
  "discount": "number",
  "categoryId": "string",
  "images": ["string"],
  "stock": "number",
  "rating": "number",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

#### Categories
```json
{
  "id": "string",
  "name": "string",
  "icon": "string",
  "createdAt": "timestamp"
}
```

#### Orders
```json
{
  "id": "string",
  "userId": "string",
  "products": [
    {
      "productId": "string",
      "quantity": "number",
      "price": "number"
    }
  ],
  "totalPrice": "number",
  "status": "pending|processing|completed|cancelled",
  "paymentMethod": "string",
  "shippingAddress": "object",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## 🔐 Security Rules (Firestore)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isAdmin() {
      return isAuthenticated() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated() && request.auth.uid == userId;
      allow create, update, delete: if isAdmin();
    }
    
    match /products/{productId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    match /orders/{orderId} {
      allow read: if isAuthenticated() && 
                     (resource.data.userId == request.auth.uid || isAdmin());
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow update, delete: if isAdmin();
    }
  }
}
```

## 🚀 آماده‌سازی برای انتشار

### Google Play
1. کلید امضا ایجاد کنید
2. فایل `key.properties` را تنظیم کنید
3. `build.gradle` را برای signing پیکربندی کنید
4. AAB بسازید و آپلود کنید

### App Store
1. سرتیفیکیت‌های iOS را تنظیم کنید
2. Provisioning Profile ایجاد کنید
3. `Info.plist` را کامل کنید
4. IPA بسازید و در App Store Connect آپلود کنید

## 📝 لاگ تغییرات

### نسخه 1.0.0
- نسخه اولیه
- احراز هویت کامل
- پنل مدیریت
- مدیریت محصولات و دسته‌بندی‌ها
- جستجو و فیلتر پیشرفته

## 🤝 مشارکت

برای مشارکت در پروژه:
1. Fork کنید
2. Branch جدید ایجاد کنید
3. تغییرات را Commit کنید
4. Push کنید
5. Pull Request ایجاد کنید

## 📄 مجوز

این پروژه تحت مجوز MIT منتشر شده است.

## 👥 تیم توسعه

- Flutter Developer
- UI/UX Designer
- Backend Developer
- QA Tester

## 📞 پشتیبانی

برای سوالات و پشتیبانی:
- Email: support@yourapp.com
- Website: https://yourapp.com

---

**ساخته شده با ❤️ و Flutter**

