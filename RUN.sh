#!/bin/bash

# راه‌اندازی و اجرای پروژه فروشگاهی Flutter

# تنظیمات Flutter
export PATH="$PATH:$HOME/flutter/bin"

# استفاده از mirror چینی برای حل مشکل دسترسی
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# رفتن به دایرکتوری پروژه
cd /home/hell-boy/Desktop/flutter-app

# نمایش وضعیت
echo "🚀 در حال اجرای پروژه..."
echo "📱 دستگاه: Linux Desktop"
echo ""

# اجرای پروژه
flutter run -d linux

