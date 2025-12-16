import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.adminPanel),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.dashboard,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'به پنل مدیریت خوش آمدید',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Statistics Cards
            Text(
              'آمار کلی',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: AppStrings.totalProducts,
                    value: '0',
                    icon: Icons.inventory_2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: AppStrings.totalUsers,
                    value: '0',
                    icon: Icons.people,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'دسته‌بندی‌ها',
                    value: '0',
                    icon: Icons.category,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    title: 'سفارشات',
                    value: '0',
                    icon: Icons.shopping_cart,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Management Options
            Text(
              'مدیریت',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            
            _ManagementCard(
              title: AppStrings.productManagement,
              subtitle: 'مدیریت محصولات، افزودن و ویرایش',
              icon: Icons.inventory_2,
              onTap: () {
                context.push(AppRoutes.adminProducts);
              },
            ),
            const SizedBox(height: 12),
            
            _ManagementCard(
              title: AppStrings.categoryManagement,
              subtitle: 'مدیریت دسته‌بندی‌ها',
              icon: Icons.category,
              onTap: () {
                context.push(AppRoutes.adminCategories);
              },
            ),
            const SizedBox(height: 12),
            
            _ManagementCard(
              title: AppStrings.userManagement,
              subtitle: 'مدیریت کاربران و دسترسی‌ها',
              icon: Icons.people,
              onTap: () {
                // TODO: Implement user management
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('این قابلیت به زودی اضافه خواهد شد'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ManagementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  
  const _ManagementCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 40),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

