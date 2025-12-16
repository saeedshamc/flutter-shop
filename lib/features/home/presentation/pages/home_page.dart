import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../product/presentation/providers/product_provider.dart';
import '../../../category/presentation/providers/category_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final featuredProducts = ref.watch(featuredProductsProvider);
    final newProducts = ref.watch(newProductsProvider);
    final categories = ref.watch(categoriesProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          // Search Icon
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.push(AppRoutes.products);
            },
          ),
          
          // Admin Panel / Profile
          if (authState.value != null)
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                // Admin Panel (if admin)
                if (currentUser.value?.isAdmin ?? false)
                  PopupMenuItem(
                    child: const ListTile(
                      leading: Icon(Icons.admin_panel_settings),
                      title: Text(AppStrings.adminPanel),
                      contentPadding: EdgeInsets.zero,
                    ),
                    onTap: () {
                      context.push(AppRoutes.adminDashboard);
                    },
                  ),
                
                // Logout
                PopupMenuItem(
                  child: const ListTile(
                    leading: Icon(Icons.logout),
                    title: Text(AppStrings.logout),
                    contentPadding: EdgeInsets.zero,
                  ),
                  onTap: () {
                    ref.read(authControllerProvider.notifier).signOut();
                  },
                ),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                context.push(AppRoutes.login);
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(featuredProductsProvider);
          ref.invalidate(newProductsProvider);
          ref.invalidate(categoriesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authState.value != null
                          ? 'خوش آمدید'
                          : 'به فروشگاه ما خوش آمدید',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (currentUser.value != null)
                      Text(
                        currentUser.value!.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.categories,
                      style: theme.textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(AppRoutes.categories);
                      },
                      child: const Text(AppStrings.seeAll),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              categories.when(
                data: (cats) => SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cats.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = cats[index];
                      return CategoryChip(
                        category: category,
                        onTap: () {
                          context.push(
                            '${AppRoutes.products}?categoryId=${category.id}',
                          );
                        },
                      );
                    },
                  ),
                ),
                loading: () => const LoadingIndicator(),
                error: (error, stack) => const SizedBox.shrink(),
              ),
              
              const SizedBox(height: 24),
              
              // Featured Products Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppStrings.featuredProducts,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 12),
              
              featuredProducts.when(
                data: (products) => SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: products.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return SizedBox(
                        width: 180,
                        child: ProductCard(
                          product: product,
                          onTap: () {
                            context.push('${AppRoutes.products}/${product.id}');
                          },
                        ),
                      );
                    },
                  ),
                ),
                loading: () => const SizedBox(
                  height: 280,
                  child: LoadingIndicator(),
                ),
                error: (error, stack) => SizedBox(
                  height: 280,
                  child: CustomErrorWidget(
                    message: error.toString(),
                    onRetry: () {
                      ref.invalidate(featuredProductsProvider);
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // New Products Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.newProducts,
                      style: theme.textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        context.push(AppRoutes.products);
                      },
                      child: const Text(AppStrings.seeAll),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              newProducts.when(
                data: (products) => GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        context.push('${AppRoutes.products}/${product.id}');
                      },
                    );
                  },
                ),
                loading: () => const SizedBox(
                  height: 400,
                  child: LoadingIndicator(),
                ),
                error: (error, stack) => SizedBox(
                  height: 400,
                  child: CustomErrorWidget(
                    message: error.toString(),
                    onRetry: () {
                      ref.invalidate(newProductsProvider);
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

