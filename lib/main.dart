import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page_simple.dart';
import 'features/product/presentation/pages/product_list_page_simple.dart';
import 'features/product/presentation/pages/product_detail_page_simple.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/auth/presentation/pages/login_page_simple.dart';
import 'features/auth/presentation/pages/register_page_simple.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'فروشگاه آنلاین',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      
      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('fa', 'IR'),
      
      // Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePageSimple(),
        '/login': (context) => const LoginPageSimple(),
        '/register': (context) => const RegisterPageSimple(),
        '/products': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return ProductListPageSimple(
            categoryId: args?['categoryId'],
          );
        },
        '/products/:id': (context) {
          final id = ModalRoute.of(context)?.settings.arguments as String? ??
              (Uri.parse(ModalRoute.of(context)!.settings.name ?? '').pathSegments.last);
          return ProductDetailPageSimple(productId: id);
        },
        '/cart': (context) => const CartPage(),
      },
      onGenerateRoute: (settings) {
        // Handle dynamic routes like /products/:id
        if (settings.name?.startsWith('/products/') ?? false) {
          final id = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => ProductDetailPageSimple(productId: id),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
