# 🚀 راهنمای نصب و راه‌اندازی

این راهنما شما را گام به گام در نصب و راه‌اندازی پروژه همراهی می‌کند.

## 📋 پیش‌نیازها

### نرم‌افزارهای مورد نیاز
- **Flutter SDK** نسخه 3.2.0 یا بالاتر
- **Dart SDK** نسخه 3.2.0 یا بالاتر
- **Android Studio** یا **VS Code** با پلاگین‌های Flutter
- **Xcode** (برای توسعه iOS - فقط macOS)
- **Git**

### حساب‌های کاربری
- حساب Firebase
- حساب Google Play Console (برای انتشار Android)
- حساب Apple Developer (برای انتشار iOS)

## 1️⃣ نصب Flutter

### Windows
```bash
# دانلود Flutter SDK از سایت رسمی
# https://docs.flutter.dev/get-started/install/windows

# افزودن به PATH
set PATH=%PATH%;C:\path\to\flutter\bin

# بررسی نصب
flutter doctor
```

### macOS/Linux
```bash
# دانلود و استخراج Flutter
cd ~/development
unzip ~/Downloads/flutter_macos_*.zip

# افزودن به PATH
export PATH="$PATH:`pwd`/flutter/bin"

# بررسی نصب
flutter doctor
```

## 2️⃣ Clone کردن پروژه

```bash
git clone <repository-url>
cd flutter-app
```

## 3️⃣ نصب وابستگی‌ها

```bash
flutter pub get
```

## 4️⃣ تنظیم Firebase

### مرحله 1: ایجاد پروژه Firebase
1. به [Firebase Console](https://console.firebase.google.com/) بروید
2. روی "Add project" کلیک کنید
3. نام پروژه را وارد کنید
4. Google Analytics را فعال کنید (اختیاری)

### مرحله 2: افزودن اپلیکیشن Android
1. در Firebase Console، روی آیکون Android کلیک کنید
2. Package name را وارد کنید: `com.example.flutter_shop_app`
3. فایل `google-services.json` را دانلود کنید
4. فایل را در `android/app/` قرار دهید

### مرحله 3: افزودن اپلیکیشن iOS
1. در Firebase Console، روی آیکون iOS کلیک کنید
2. Bundle ID را وارد کنید: `com.example.flutterShopApp`
3. فایل `GoogleService-Info.plist` را دانلود کنید
4. فایل را در `ios/Runner/` قرار دهید

### مرحله 4: نصب FlutterFire CLI
```bash
dart pub global activate flutterfire_cli

flutterfire configure
```

این دستور به صورت خودکار Firebase را برای پروژه شما پیکربندی می‌کند.

### مرحله 5: فعال‌سازی سرویس‌های Firebase

#### Authentication
1. در Firebase Console به **Authentication** بروید
2. روی **Get Started** کلیک کنید
3. **Email/Password** را فعال کنید
4. (اختیاری) **Google Sign-In** را فعال کنید

#### Firestore Database
1. در Firebase Console به **Firestore Database** بروید
2. روی **Create database** کلیک کنید
3. **Start in test mode** را انتخاب کنید (برای توسعه)
4. Location را انتخاب کنید

#### Storage
1. در Firebase Console به **Storage** بروید
2. روی **Get Started** کلیک کنید
3. Security rules پیش‌فرض را بپذیرید

## 5️⃣ تنظیم Firestore Security Rules

در Firebase Console، به **Firestore Database > Rules** بروید و قوانین زیر را اضافه کنید:

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

## 6️⃣ تنظیم Storage Security Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    match /categories/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## 7️⃣ Generate کردن کدهای خودکار

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

این دستور فایل‌های `.g.dart` و `.freezed.dart` را ایجاد می‌کند.

## 8️⃣ اجرای پروژه

### Mode Development
```bash
flutter run --dart-define=ENVIRONMENT=dev
```

### Mode Production
```bash
flutter run --dart-define=ENVIRONMENT=prod --release
```

## 9️⃣ ایجاد کاربر Admin اولیه

1. یک حساب کاربری در اپلیکیشن ایجاد کنید
2. در Firebase Console به **Firestore Database** بروید
3. Collection `users` را باز کنید
4. Document مربوط به کاربر خود را پیدا کنید
5. فیلد `role` را به `admin` تغییر دهید

## 🔟 Build کردن برای انتشار

### Android (AAB)
```bash
flutter build appbundle --release
```

فایل خروجی: `build/app/outputs/bundle/release/app-release.aab`

### Android (APK)
```bash
flutter build apk --release --split-per-abi
```

فایل‌های خروجی در: `build/app/outputs/flutter-apk/`

### iOS
```bash
flutter build ipa --release
```

فایل خروجی: `build/ios/ipa/`

## ⚠️ مشکلات رایج و راه‌حل‌ها

### خطای "No Firebase App"
**راه‌حل**: مطمئن شوید `Firebase.initializeApp()` در `main()` فراخوانی شده است.

### خطای Build در Android
**راه‌حل**: 
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### خطای Firestore Permission Denied
**راه‌حل**: بررسی کنید Security Rules را درست تنظیم کرده‌اید و کاربر authenticated است.

### خطای Code Generation
**راه‌حل**:
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📝 Environment Variables

فایل `.env` در root پروژه ایجاد کنید:

```env
# Development
API_BASE_URL=https://dev-api.yourshop.com
API_KEY=your_dev_api_key

# Production
# API_BASE_URL=https://api.yourshop.com
# API_KEY=your_prod_api_key
```

## 🧪 اجرای تست‌ها

```bash
# Unit Tests
flutter test

# Widget Tests
flutter test test/widget_test

# Integration Tests
flutter test integration_test
```

## 🚀 CI/CD با GitHub Actions

فایل `.github/workflows/main.yml` برای CI/CD اضافه کنید.

## 📱 دیباگ در دستگاه واقعی

### Android
1. Developer Options را در گوشی فعال کنید
2. USB Debugging را فعال کنید
3. گوشی را به کامپیوتر وصل کنید
4. دستور `flutter devices` را اجرا کنید
5. دستور `flutter run` را اجرا کنید

### iOS
1. iPhone را به Mac وصل کنید
2. در Xcode، پروژه را باز کنید
3. Signing & Capabilities را تنظیم کنید
4. دستور `flutter run` را اجرا کنید

## 🎯 قدم‌های بعدی

1. ✅ افزودن تصاویر و آیکون‌های اپلیکیشن
2. ✅ پیاده‌سازی payment gateway
3. ✅ افزودن push notifications
4. ✅ پیاده‌سازی cart و checkout
5. ✅ افزودن review و rating system
6. ✅ پیاده‌سازی wishlist
7. ✅ افزودن order tracking
8. ✅ بهینه‌سازی performance

## 💬 پشتیبانی

در صورت بروز مشکل:
- Issues در GitHub را بررسی کنید
- سوال خود را در بخش Discussions مطرح کنید
- مستندات Flutter و Firebase را مطالعه کنید

---

**موفق باشید! 🎉**

