import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatter.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../providers/product_provider.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;
  
  const ProductDetailPage({
    super.key,
    required this.productId,
  });
  
  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  final _pageController = PageController();
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productAsync = ref.watch(productDetailsProvider(widget.productId));
    
    return Scaffold(
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return const CustomErrorWidget(
              message: 'محصول یافت نشد',
            );
          }
          
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: product.images.isNotEmpty
                      ? Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: product.images.length,
                              itemBuilder: (context, index) {
                                return CachedNetworkImage(
                                  imageUrl: product.images[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: AppColors.shimmerBase,
                                    child: const LoadingIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: AppColors.shimmerBase,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 64,
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            // Page Indicator
                            if (product.images.length > 1)
                              Positioned(
                                bottom: 16,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: SmoothPageIndicator(
                                    controller: _pageController,
                                    count: product.images.length,
                                    effect: WormEffect(
                                      dotWidth: 8,
                                      dotHeight: 8,
                                      activeDotColor: theme.colorScheme.primary,
                                      dotColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : Container(
                          color: AppColors.shimmerBase,
                          child: const Icon(
                            Icons.image,
                            size: 64,
                          ),
                        ),
                ),
              ),
              
              // Product Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.name,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      
                      // Brand
                      Row(
                        children: [
                          Text(
                            '${AppStrings.brand}: ',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            product.brand,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Price Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.dividerColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product.hasDiscount) ...[
                                  Text(
                                    Formatter.price(product.price),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: theme.textTheme.bodySmall?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                                Text(
                                  Formatter.price(product.finalPrice),
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            
                            if (product.hasDiscount)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.discount,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  Formatter.discountPercentage(product.discount),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Stock Status
                      Row(
                        children: [
                          Icon(
                            product.inStock
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: product.inStock
                                ? AppColors.success
                                : AppColors.error,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product.inStock
                                ? '${AppStrings.inStock} (${product.stock} عدد)'
                                : AppStrings.outOfStock,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: product.inStock
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Description
                      Text(
                        AppStrings.description,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 80), // Space for button
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) => Center(
          child: CustomErrorWidget(
            message: error.toString(),
            onRetry: () {
              ref.invalidate(productDetailsProvider(widget.productId));
            },
          ),
        ),
      ),
      
      // Add to Cart Button (Bottom)
      bottomNavigationBar: productAsync.maybeWhen(
        data: (product) {
          if (product == null || !product.inStock) return null;
          
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Add to cart functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('این قابلیت به زودی اضافه خواهد شد'),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text(AppStrings.addToCart),
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }
}

