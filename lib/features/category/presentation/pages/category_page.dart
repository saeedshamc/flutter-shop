import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/category_provider.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.categories),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const EmptyState(
              message: AppStrings.noCategoriesFound,
              icon: Icons.category_outlined,
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(categoriesProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final category = categories[index];
                
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: category.icon != null
                        ? Text(
                            category.icon!,
                            style: const TextStyle(fontSize: 32),
                          )
                        : const Icon(Icons.category, size: 32),
                    title: Text(
                      category.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: category.description != null
                        ? Text(category.description!)
                        : null,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${category.productCount}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'محصول',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    onTap: () {
                      context.push(
                        '${AppRoutes.products}?categoryId=${category.id}',
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stack) => CustomErrorWidget(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(categoriesProvider);
          },
        ),
      ),
    );
  }
}

