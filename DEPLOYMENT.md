# 🚀 راهنمای انتشار (Deployment)

این راهنما مراحل کامل انتشار اپلیکیشن در Google Play و App Store را توضیح می‌دهد.

## 📱 Google Play Store (Android)

### مرحله 1: آماده‌سازی فایل‌های مورد نیاز

#### 1.1 ایجاد Keystore
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

#### 1.2 تنظیم key.properties

فایل `android/key.properties` ایجاد کنید:
```properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<path to keystore file>
```

#### 1.3 پیکربندی build.gradle

فایل `android/app/build.gradle` را ویرایش کنید:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### مرحله 2: Build AAB

```bash
flutter build appbundle --release
```

فایل خروجی: `build/app/outputs/bundle/release/app-release.aab`

### مرحله 3: آماده‌سازی Google Play Console

#### 3.1 ایجاد اپلیکیشن
1. به [Google Play Console](https://play.google.com/console) بروید
2. "Create app" کلیک کنید
3. اطلاعات اپلیکیشن را وارد کنید

#### 3.2 تنظیمات Store Listing

**عنوان** (30 کاراکتر):
```
فروشگاه آنلاین
```

**توضیح کوتاه** (80 کاراکتر):
```
خرید آسان و سریع محصولات با بهترین قیمت
```

**توضیح کامل** (4000 کاراکتر):
```
فروشگاه آنلاین یک اپلیکیشن جامع و کامل برای خرید آنلاین است.

ویژگی‌ها:
• هزاران محصول در دسته‌بندی‌های مختلف
• جستجوی پیشرفته و فیلترهای هوشمند
• سبد خرید و پرداخت آنلاین امن
• پیگیری سفارش
• پشتیبانی 24 ساعته

با فروشگاه آنلاین، خرید آسان است!
```

#### 3.3 آپلود تصاویر

**Screenshot ها** (حداقل 2 عدد):
- Resolution: 16:9 یا 9:16
- Format: PNG یا JPEG
- Size: حداکثر 8 MB

**Feature Graphic**:
- Size: 1024 x 500 px
- Format: PNG یا JPEG

**App Icon**:
- Size: 512 x 512 px
- Format: PNG

#### 3.4 دسته‌بندی و تگ‌ها

- **Application type**: Applications
- **Category**: Shopping
- **Tags**: خرید، فروشگاه، آنلاین

### مرحله 4: آپلود AAB

1. به بخش "Release" > "Production" بروید
2. "Create new release" کلیک کنید
3. فایل AAB را آپلود کنید
4. Release notes را اضافه کنید
5. "Review release" کلیک کنید
6. "Start rollout to production" کلیک کنید

### مرحله 5: App Content

#### دسته‌بندی سنی
- انتخاب "Everyone" یا مناسب

#### Privacy Policy
URL privacy policy خود را اضافه کنید:
```
https://yourapp.com/privacy-policy
```

#### Data Safety
اطلاعات جمع‌آوری شده را مشخص کنید:
- User account data
- Location
- Personal info
- Financial info (اگر دارید)

---

## 🍎 App Store (iOS)

### مرحله 1: تنظیمات Xcode

#### 1.1 باز کردن در Xcode
```bash
open ios/Runner.xcworkspace
```

#### 1.2 تنظیمات Signing

1. Runner را در Navigator انتخاب کنید
2. Target > Runner را انتخاب کنید
3. Signing & Capabilities
4. Team خود را انتخاب کنید
5. Bundle Identifier را وارد کنید: `com.example.flutterShopApp`

### مرحله 2: Build IPA

```bash
flutter build ipa --release
```

یا از Xcode:
1. Product > Archive
2. منتظر بمانید تا archive کامل شود
3. Window > Organizer
4. Archive را انتخاب و Distribute App کلیک کنید

### مرحله 3: App Store Connect

#### 3.1 ایجاد اپلیکیشن

1. به [App Store Connect](https://appstoreconnect.apple.com/) بروید
2. My Apps > + > New App
3. اطلاعات را وارد کنید:
   - Platform: iOS
   - Name: فروشگاه آنلاین
   - Primary Language: Persian
   - Bundle ID: com.example.flutterShopApp
   - SKU: SHOP001

#### 3.2 App Information

**Subtitle** (30 کاراکتر):
```
خرید آسان و سریع
```

**Description** (4000 کاراکتر):
```
فروشگاه آنلاین - بهترین تجربه خرید آنلاین

ویژگی‌های برجسته:
• هزاران محصول متنوع
• جستجوی هوشمند
• پرداخت امن
• پیگیری سفارش
• پشتیبانی عالی

دانلود رایگان!
```

**Keywords** (100 کاراکتر):
```
خرید,فروشگاه,آنلاین,تخفیف,محصول
```

**Support URL**:
```
https://yourapp.com/support
```

**Marketing URL** (اختیاری):
```
https://yourapp.com
```

#### 3.3 آپلود تصاویر

**iPhone Screenshots** (حداقل 3 عدد):
- iPhone 6.7": 1290 x 2796 px
- iPhone 6.5": 1242 x 2688 px

**iPad Screenshots** (اختیاری):
- 12.9": 2048 x 2732 px

**App Preview Video** (اختیاری):
- Duration: 15-30 seconds
- Format: M4V, MP4, MOV

### مرحله 4: Pricing and Availability

- **Price**: Free (رایگان) یا قیمت دلخواه
- **Availability**: All countries/regions

### مرحله 5: App Privacy

توضیح دهید چه داده‌هایی جمع‌آوری می‌شود:
- Contact Info
- User Content
- Identifiers
- Usage Data

### مرحله 6: آپلود Build

1. در Xcode Archive کنید
2. Distribute App > App Store Connect
3. Upload
4. منتظر Processing بمانید
5. در App Store Connect، Build را انتخاب کنید

### مرحله 7: ارسال برای Review

1. تمام بخش‌ها را کامل کنید
2. "Submit for Review" کلیک کنید
3. منتظر Review (معمولاً 1-3 روز)

---

## 🔄 CI/CD با GitHub Actions

### فایل .github/workflows/deploy.yml

```yaml
name: Deploy to Stores

on:
  push:
    branches:
      - main
    tags:
      - 'v*'

jobs:
  deploy-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '11'
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - run: flutter pub get
      
      - run: flutter build appbundle --release
      
      - uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJson: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.example.flutter_shop_app
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: production
          
  deploy-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - run: flutter pub get
      
      - run: flutter build ipa --release
      
      - uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: build/ios/ipa/*.ipa
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_API_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_API_PRIVATE_KEY }}
```

---

## 📊 بعد از انتشار

### Analytics

1. **Firebase Analytics** را راه‌اندازی کنید
2. **Crashlytics** برای tracking errors
3. **Google Analytics for Firebase**

### Monitoring

1. بررسی reviews و ratings
2. پاسخ به نظرات کاربران
3. بررسی crash reports
4. تحلیل user behavior

### Updates

#### Android
```bash
# افزایش version
# در pubspec.yaml: version: 1.0.1+2

flutter build appbundle --release
# آپلود در Google Play Console
```

#### iOS
```bash
# افزایش version
# در pubspec.yaml: version: 1.0.1+2

flutter build ipa --release
# Archive و Upload در Xcode
```

---

## 🎯 چک‌لیست قبل از انتشار

### عمومی
- [ ] تست کامل اپلیکیشن
- [ ] بررسی performance
- [ ] بررسی security
- [ ] آماده‌سازی مستندات
- [ ] تهیه screenshots و videos

### Android
- [ ] Signed APK/AAB
- [ ] Google Play Console setup
- [ ] Privacy policy
- [ ] Store listing کامل
- [ ] تست در دستگاه‌های مختلف

### iOS
- [ ] App Store Connect setup
- [ ] Certificate و Provisioning
- [ ] App Store listing کامل
- [ ] تست در دستگاه‌های مختلف
- [ ] Archive در Xcode

---

## 💡 نکات مهم

1. ✅ همیشه version را افزایش دهید
2. ✅ Release notes واضح بنویسید
3. ✅ از Staged Rollout استفاده کنید
4. ✅ Beta testing انجام دهید
5. ✅ Backup از keystore بگیرید
6. ✅ Monitor کنید و سریع update کنید

---

**موفق باشید! 🚀**

