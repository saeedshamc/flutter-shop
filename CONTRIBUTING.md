# 🤝 راهنمای مشارکت

از اینکه می‌خواهید در این پروژه مشارکت کنید، متشکریم! 🎉

## 📋 فهرست مطالب

- [Code of Conduct](#code-of-conduct)
- [شروع کار](#شروع-کار)
- [نحوه مشارکت](#نحوه-مشارکت)
- [استانداردهای کد](#استانداردهای-کد)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

با مشارکت در این پروژه، شما موافقت می‌کنید که به [Code of Conduct](CODE_OF_CONDUCT.md) ما پایبند باشید.

## شروع کار

### 1. Fork کردن Repository

Repository را در حساب GitHub خود fork کنید.

### 2. Clone کردن

```bash
git clone https://github.com/your-username/flutter-app.git
cd flutter-app
```

### 3. نصب Dependencies

```bash
flutter pub get
flutter pub run build_runner build
```

### 4. ایجاد Branch جدید

```bash
git checkout -b feature/your-feature-name
```

## نحوه مشارکت

### گزارش Bug

اگر باگی پیدا کردید:

1. بررسی کنید که قبلاً گزارش نشده باشد
2. Issue جدید با template مربوطه ایجاد کنید
3. توضیحات کامل و مراحل بازتولید را ارائه دهید
4. اسکرین‌شات یا لاگ اضافه کنید

### پیشنهاد Feature

برای پیشنهاد feature جدید:

1. Issue با برچسب "enhancement" ایجاد کنید
2. توضیح دهید چرا این feature مفید است
3. نمونه‌های use case ارائه دهید
4. منتظر بازخورد باشید

### ارسال Pull Request

1. تغییرات خود را commit کنید
2. تست‌ها را اجرا کنید
3. Push به branch خود کنید
4. Pull Request ایجاد کنید

## استانداردهای کد

### Dart Style Guide

از [Effective Dart](https://dart.dev/guides/language/effective-dart) پیروی کنید.

### Formatting

```bash
dart format .
```

### Linting

```bash
dart analyze
```

### مثال کد خوب

```dart
// ✅ خوب
class ProductRepository {
  const ProductRepository({
    required this.firebaseService,
  });
  
  final FirebaseService firebaseService;
  
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      // Implementation
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

// ❌ بد
class ProductRepo {
  var firebase;
  
  getProducts() async {
    var result = await firebase.get();
    return result;
  }
}
```

### نامگذاری

- **Classes**: PascalCase (`ProductRepository`)
- **Functions**: camelCase (`getProducts()`)
- **Variables**: camelCase (`productList`)
- **Constants**: lowerCamelCase (`apiBaseUrl`)
- **Files**: snake_case (`product_repository.dart`)

### Documentation

```dart
/// محصولات را از سرور دریافت می‌کند.
/// 
/// [limit] تعداد محصولات برای دریافت
/// [categoryId] فیلتر بر اساس دسته‌بندی
/// 
/// Returns [Either<Failure, List<Product>>]
Future<Either<Failure, List<Product>>> getProducts({
  int? limit,
  String? categoryId,
}) async {
  // Implementation
}
```

## Commit Messages

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: Feature جدید
- `fix`: رفع باگ
- `docs`: تغییرات مستندات
- `style`: فرمت، نقطه‌گذاری، و غیره
- `refactor`: تغییر کد بدون تغییر عملکرد
- `perf`: بهبود performance
- `test`: اضافه کردن تست
- `chore`: تغییرات build process یا ابزارها

### مثال‌ها

```bash
feat(auth): add google sign in

Implemented google sign in functionality using firebase auth

Closes #123
```

```bash
fix(product): resolve image loading issue

Fixed an issue where product images were not loading
on slow connections

Fixes #456
```

## Pull Request Process

### 1. قبل از ارسال PR

- [ ] کد را format کرده‌اید
- [ ] تست‌ها را اجرا کرده‌اید
- [ ] مستندات را به‌روز کرده‌اید
- [ ] تغییرات را در CHANGELOG اضافه کرده‌اید

### 2. Template PR

```markdown
## توضیحات
[توضیح مختصری از تغییرات]

## نوع تغییر
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## چک‌لیست
- [ ] کد format شده است
- [ ] تست‌ها pass می‌شوند
- [ ] مستندات به‌روز شده است

## اسکرین‌شات‌ها (در صورت نیاز)
```

### 3. Review Process

1. دو reviewer باید PR را approve کنند
2. تمام تست‌ها باید pass شوند
3. Conflicts را resolve کنید
4. پس از approval، merge خواهد شد

## 🧪 Testing

### Unit Tests

```bash
flutter test
```

### Widget Tests

```bash
flutter test test/widget_test
```

### Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📝 مستندات

### Inline Documentation

- از `///` برای public API استفاده کنید
- توضیحات کامل و واضح بنویسید
- مثال‌ها اضافه کنید

### Markdown Files

- `README.md`: نمای کلی پروژه
- `SETUP_GUIDE.md`: راهنمای نصب
- `ARCHITECTURE.md`: معماری پروژه
- `API_DOCUMENTATION.md`: مستندات API

## 🎨 UI/UX Guidelines

1. از Material Design 3 پیروی کنید
2. طراحی responsive باشد
3. از animations مناسب استفاده کنید
4. Accessibility را در نظر بگیرید
5. Dark mode support داشته باشد

## 🐛 Debugging

### Tips

1. از `debugPrint()` برای لاگ استفاده کنید
2. از Flutter DevTools استفاده کنید
3. Performance profiling انجام دهید
4. Memory leaks را بررسی کنید

## 📞 ارتباط

- **Issues**: برای گزارش باگ و پیشنهاد feature
- **Discussions**: برای سوالات عمومی
- **Email**: support@yourapp.com

## 🙏 تشکر

از همه مشارکت‌کنندگان تشکر می‌کنیم:

<!-- ALL-CONTRIBUTORS-LIST:START -->
<!-- Contributors will be added here -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

---

**Happy Coding! 💻✨**

