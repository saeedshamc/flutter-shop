import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatter.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailPageSimple extends ConsumerStatefulWidget {
  final ProductModel? product;
  final String? productId;
  
  const ProductDetailPageSimple({
    super.key,
    this.product,
    this.productId,
  });
  
  @override
  ConsumerState<ProductDetailPageSimple> createState() => _ProductDetailPageSimpleState();
}

class _ProductDetailPageSimpleState extends ConsumerState<ProductDetailPageSimple> {
  final _pageController = PageController();
  late final ProductModel _product;
  int _currentImageIndex = 0;
  int _quantity = 1;
  
  @override
  void initState() {
    super.initState();
    _product = widget.product ??
        MockData.getProducts().firstWhere(
          (p) => p.id == widget.productId,
          orElse: () => MockData.getProducts().first,
        );
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  void _addToCart() {
    ref.read(cartProvider.notifier).addItem(
      _product,
      _quantity,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_product.name} به سبد خرید اضافه شد'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'مشاهده سبد',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pop(context);
            // TODO: Navigate to cart
          },
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 600;
    final product = _product;
    final images = product.images.isNotEmpty 
        ? product.images 
        : ['https://via.placeholder.com/400'];
    
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar with Image
            SliverAppBar(
              expandedHeight: isSmall ? 260 : 320,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() => _currentImageIndex = index);
                      },
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: images[index],
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
                    if (images.length > 1)
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: images.length,
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
                ),
              ),
            ),
            
            // Product Details
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(isSmall ? 14 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: isSmall
                          ? theme.textTheme.titleLarge
                          : theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    
                    // Brand and Rating
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
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.ratingActive,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating} (${product.reviewCount})',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Price Section
                    Container(
                      padding: EdgeInsets.all(isSmall ? 14 : 16),
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
                        Expanded(
                          child: Text(
                            product.inStock
                                ? '${AppStrings.inStock} (${product.stock} عدد)'
                                : AppStrings.outOfStock,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: product.inStock
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    // Quantity Selector
                    if (product.inStock) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'تعداد: ',
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.dividerColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: _quantity > 1
                                      ? () => setState(() => _quantity--)
                                      : null,
                                  visualDensity: VisualDensity.compact,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    '$_quantity',
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: _quantity < product.stock
                                      ? () => setState(() => _quantity++)
                                      : null,
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 20),
                    
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
        ),
      ),
      
      // Add to Cart Button
      bottomNavigationBar: product.inStock
          ? SafeArea(
              child: Container(
                padding: EdgeInsets.all(isSmall ? 12 : 16),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _addToCart,
                        icon: const Icon(Icons.shopping_cart),
                        label: Text('${AppStrings.addToCart} ($_quantity)'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: isSmall ? 14 : 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
