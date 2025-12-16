import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider_simple.dart';
import '../../../cart/presentation/pages/cart_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProviderSimple);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      authState.name?.substring(0, 1).toUpperCase() ?? 'U',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authState.name ?? 'کاربر',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authState.email ?? '',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Menu Items
          _ProfileMenuItem(
            icon: Icons.shopping_cart,
            title: 'سبد خرید',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
          _ProfileMenuItem(
            icon: Icons.receipt_long,
            title: 'سفارش‌های من',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سفارش‌ها به زودی اضافه می‌شود')),
              );
            },
          ),
          _ProfileMenuItem(
            icon: Icons.favorite,
            title: 'علاقه‌مندی‌ها',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('علاقه‌مندی‌ها به زودی اضافه می‌شود')),
              );
            },
          ),
          _ProfileMenuItem(
            icon: Icons.location_on,
            title: 'آدرس‌ها',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('آدرس‌ها به زودی اضافه می‌شود')),
              );
            },
          ),
          _ProfileMenuItem(
            icon: Icons.settings,
            title: 'تنظیمات',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تنظیمات به زودی اضافه می‌شود')),
              );
            },
          ),
          const Divider(),
          _ProfileMenuItem(
            icon: Icons.logout,
            title: AppStrings.logout,
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('خروج'),
                  content: const Text('آیا از خروج اطمینان دارید؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(AppStrings.cancel),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(authProviderSimple.notifier).logout();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('با موفقیت خارج شدید'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      child: const Text(AppStrings.logout),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? theme.colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

