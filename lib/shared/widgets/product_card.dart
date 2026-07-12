import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatter.dart';
import '../../shared/models/product_model.dart';
import '../../features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'product-image-${product.id}',
                    child: product.primaryImage.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.primaryImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.shimmerBase,
                              child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.shimmerBase,
                              child: const Icon(Icons.image_not_supported),
                            ),
                          )
                        : Container(
                            color: AppColors.shimmerBase,
                            child: const Icon(
                              Icons.image,
                              size: 48,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                  ),

                  // Subtle bottom gradient so the badges/text stay readable
                  // over any image
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.25),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Discount Badge
                  if (product.hasDiscount)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.discount, Color(0xFFF97316)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.discount.withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          Formatter.discountPercentage(product.discount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Quick add-to-cart button
                  if (product.inStock)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        elevation: 3,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            ref.read(cartProvider.notifier).addItem(product, 1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('${product.name} به سبد خرید اضافه شد'),
                                backgroundColor: AppColors.success,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.add_shopping_cart,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Rating
                    if (product.rating > 0)
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 14, color: AppColors.ratingActive),
                          const SizedBox(width: 2),
                          Text(
                            '${product.rating}',
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              product.brand,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        product.brand,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    const Spacer(),
                    const SizedBox(height: 6),

                    // Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            Formatter.price(product.finalPrice),
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (product.hasDiscount)
                      Text(
                        Formatter.price(product.price),
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),

                    // Stock Status
                    if (!product.inStock) ...[
                      const SizedBox(height: 4),
                      Text(
                        'ناموجود',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
