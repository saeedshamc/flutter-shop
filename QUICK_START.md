# 🚀 راهنمای سریع اجرا

## ✅ پروژه آماده اجراست!

### 📱 اجرا روی Linux Desktop

```bash
# 1. فعال کردن Flutter در PATH (اگر نشده)
export PATH="$PATH:$HOME/flutter/bin"

# 2. استفاده از mirror چینی (برای حل مشکل دسترسی)
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 3. اجرای پروژه
cd /home/hell-boy/Desktop/flutter-app
flutter run -d linux -t lib/main_simple.dart
```

### 🌐 اجرا روی Chrome (Web)

```bash
flutter run -d chrome -t lib/main_simple.dart
```

### 📱 اجرا روی Android Emulator

```bash
# 1. لیست emulator ها
flutter emulators

# 2. اجرای emulator
flutter emulators --launch <emulator_id>

# 3. اجرای پروژه
flutter run -d <device_id>
```

## 🔧 تنظیمات دائمی

برای اینکه هر بار مجبور نباشی mirror رو تنظیم کنی، این رو به `~/.zshrc` اضافه کن:

```bash
echo 'export PUB_HOSTED_URL=https://pub.flutter-io.cn' >> ~/.zshrc
echo 'export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn' >> ~/.zshrc
source ~/.zshrc
```

## 📝 نسخه‌های مختلف

### نسخه ساده (بدون Firebase)
```bash
flutter run -t lib/main_simple.dart
```

### نسخه کامل (با Firebase)
```bash
# اول باید Firebase رو راه‌اندازی کنی
flutter run -t lib/main.dart
```

## ⚠️ مشکلات رایج

### مشکل: "command not found: flutter"
**راه‌حل**: Flutter رو به PATH اضافه کن:
```bash
export PATH="$PATH:$HOME/flutter/bin"
```

### مشکل: "authorization failed"
**راه‌حل**: از mirror چینی استفاده کن (دستورات بالا)

### مشکل: "No devices found"
**راه‌حل**: 
- برای Linux: `flutter config --enable-linux-desktop`
- برای Web: Chrome رو نصب کن
- برای Android: Android Studio و emulator رو نصب کن

## 🎯 دستورات مفید

```bash
# بررسی دستگاه‌ها
flutter devices

# بررسی وضعیت Flutter
flutter doctor

# نصب packages
flutter pub get

# پاک کردن cache
flutter clean

# Build برای release
flutter build linux --release
```

---

**موفق باشی! 🚀**

