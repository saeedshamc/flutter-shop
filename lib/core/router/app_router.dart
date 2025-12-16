import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/product_list_page.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';
import '../../features/category/presentation/pages/category_page.dart';
import '../../features/admin/presentation/pages/admin_dashboard_page.dart';
import '../../features/admin/presentation/pages/product_management_page.dart';
import '../../features/admin/presentation/pages/category_management_page.dart';
import '../../features/admin/presentation/pages/add_edit_product_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// Route Names
class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/';
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String categories = '/categories';
  static const String adminDashboard = '/admin';
  static const String adminProducts = '/admin/products';
  static const String adminCategories = '/admin/categories';
  static const String adminAddProduct = '/admin/products/add';
  static const String adminEditProduct = '/admin/products/edit/:id';
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == AppRoutes.login ||
                         state.matchedLocation == AppRoutes.register ||
                         state.matchedLocation == AppRoutes.forgotPassword;
      
      // If not logged in and trying to access admin panel
      if (!isLoggedIn && state.matchedLocation.startsWith('/admin')) {
        return AppRoutes.login;
      }
      
      // If logged in and trying to access auth pages
      if (isLoggedIn && isLoggingIn) {
        return AppRoutes.home;
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.products,
        name: 'products',
        builder: (context, state) => const ProductListPage(),
      ),
      GoRoute(
        path: '/products/:id',
        name: 'product-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailPage(productId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.categories,
        name: 'categories',
        builder: (context, state) => const CategoryPage(),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'admin-dashboard',
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.adminProducts,
        name: 'admin-products',
        builder: (context, state) => const ProductManagementPage(),
      ),
      GoRoute(
        path: AppRoutes.adminCategories,
        name: 'admin-categories',
        builder: (context, state) => const CategoryManagementPage(),
      ),
      GoRoute(
        path: AppRoutes.adminAddProduct,
        name: 'admin-add-product',
        builder: (context, state) => const AddEditProductPage(),
      ),
      GoRoute(
        path: '/admin/products/edit/:id',
        name: 'admin-edit-product',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return AddEditProductPage(productId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('صفحه یافت نشد: ${state.uri.path}'),
      ),
    ),
  );
});

