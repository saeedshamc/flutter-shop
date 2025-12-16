import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MySimpleApp());
}

class MySimpleApp extends StatelessWidget {
  const MySimpleApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'فروشگاه آنلاین',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      locale: const Locale('fa', 'IR'),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, size: 80, color: Colors.blue),
              SizedBox(height: 24),
              Text(
                'فروشگاه آنلاین',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'پروژه با موفقیت ایجاد شد! 🎉',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'برای اجرای کامل، Firebase را راه‌اندازی کنید',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

