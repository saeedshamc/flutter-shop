import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatter.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../product/presentation/providers/product_provider.dart';

class ProductManagementPage extends ConsumerStatefulWidget {
  const ProductManagementPage({super.key});
  
  @override
  ConsumerState<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends ConsumerState<ProductManagementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productListControllerProvider.notifier).loadProducts(refresh: true);
    });
  }
  
  Future<void> _handleDelete(String productId, String productName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.delete),
        content: Text('آیا از حذف "$productName" اطمینان دارید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
    
    if (confirmed == true && mounted) {
      final success = await ref
          .read(productCrudControllerProvider.notifier)
          .deleteProduct(productId);
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.productDeletedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          ref.read(productListControllerProvider.notifier).loadProducts(refresh: true);
        } else {
          final error = ref.read(productCrudControllerProvider).error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error ?? 'خطا در حذف محصول'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productState = ref.watch(productListControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.productManagement),
      ),
      body: productState.products.isEmpty && !productState.isLoading
          ? EmptyState(
              message: AppStrings.noProductsFound,
              icon: Icons.inventory_2_outlined,
              onRetry: () {
                ref.read(productListControllerProvider.notifier)
                    .loadProducts(refresh: true);
              },
            )
          : RefreshIndicator(
              onRefresh: () async {
                ref.read(productListControllerProvider.notifier)
                    .loadProducts(refresh: true);
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: productState.products.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = productState.products[index];
                  
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: SizedBox(
                        width: 60,
                        height: 60,
                        child: product.primaryImage.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: product.primaryImage,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: AppColors.shimmerBase,
                                  child: const LoadingIndicator(size: 20),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: AppColors.shimmerBase,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              )
                            : Container(
                                color: AppColors.shimmerBase,
                                child: const Icon(Icons.image),
                              ),
                      ),
                      title: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(product.brand),
                          const SizedBox(height: 4),
                          Text(
                            Formatter.price(product.finalPrice),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text(AppStrings.edit),
                              ],
                            ),
                            onTap: () {
                              Future.delayed(Duration.zero, () {
                                context.push(
                                  '/admin/products/edit/${product.id}',
                                );
                              });
                            },
                          ),
                          PopupMenuItem(
                            child: const Row(
                              children: [
                                Icon(Icons.delete, color: AppColors.error),
                                SizedBox(width: 8),
                                Text(
                                  AppStrings.delete,
                                  style: TextStyle(color: AppColors.error),
                                ),
                              ],
                            ),
                            onTap: () {
                              Future.delayed(Duration.zero, () {
                                _handleDelete(product.id, product.name);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.adminAddProduct);
        },
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addProduct),
      ),
    );
  }
}

