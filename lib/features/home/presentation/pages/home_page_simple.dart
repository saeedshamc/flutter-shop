import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/models/category_model.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../product/presentation/pages/product_list_page_simple.dart';
import '../../../product/presentation/pages/product_detail_page_simple.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider_simple.dart';
import '../../../auth/presentation/pages/login_page_simple.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class HomePageSimple extends ConsumerStatefulWidget {
  const HomePageSimple({super.key});
  
  @override
  ConsumerState<HomePageSimple> createState() => _HomePageSimpleState();
}

class _HomePageSimpleState extends ConsumerState<HomePageSimple> {
  late List<ProductModel> _featuredProducts;
  
  @override
  void initState() {
    super.initState();
    _featuredProducts = List<ProductModel>.from(MockData.getFeaturedProducts());
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 600;
    final categories = MockData.getCategories();
    final newProducts = MockData.getNewProducts();
    final authState = ref.watch(authProviderSimple);
    final cartState = ref.watch(cartProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductListPageSimple(),
                ),
              );
            },
            tooltip: 'جستجو',
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartState.itemCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
            tooltip: 'سبد خرید',
          ),
          // Profile/Login Button
          IconButton(
            icon: Icon(authState.isAuthenticated ? Icons.person : Icons.login),
            onPressed: () {
              if (authState.isAuthenticated) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPageSimple(),
                  ),
                );
              }
            },
            tooltip: authState.isAuthenticated ? 'پروفایل' : 'ورود',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
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
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'به فروشگاه آنلاین خوش آمدید',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'بهترین محصولات با بهترین قیمت و تخفیف‌های ویژه',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductListPageSimple(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('مشاهده همه محصولات'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Categories Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isSmall ? 12 : 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.categories,
                      style: theme.textTheme.headlineSmall,
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to categories page
                      },
                      child: const Text(AppStrings.seeAll),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              SizedBox(
                height: isSmall ? 56 : 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: isSmall ? 12 : 16),
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => SizedBox(width: isSmall ? 10 : 12),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryChip(
                      category: category,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListPageSimple(
                              categoryId: category.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Featured Products Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmall ? 12 : 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.featured,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.featuredProducts,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductListPageSimple(),
                          ),
                        );
                      },
                      child: const Text(AppStrings.seeAll),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              SizedBox(
                height: isSmall ? 260 : 300,
                child: ReorderableListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: isSmall ? 12 : 16),
                  itemCount: _featuredProducts.length,
                  proxyDecorator: (child, index, animation) => child,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final item = _featuredProducts.removeAt(oldIndex);
                      _featuredProducts.insert(newIndex, item);
                    });
                  },
                  itemBuilder: (context, index) {
                    final product = _featuredProducts[index];
                    return Padding(
                      key: ValueKey(product.id),
                      padding: EdgeInsets.only(right: index == _featuredProducts.length - 1 ? 0 : (isSmall ? 12 : 16)),
                      child: ReorderableDragStartListener(
                        index: index,
                        child: SizedBox(
                          width: isSmall ? 170 : 200,
                          child: ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPageSimple(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 32),
              
              // New Products Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmall ? 12 : 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.new_releases,
                          color: AppColors.accent,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.newProducts,
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductListPageSimple(),
                          ),
                        );
                      },
                      child: const Text(AppStrings.seeAll),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: isSmall ? 12 : 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isSmall ? 2 : 3,
                  crossAxisSpacing: isSmall ? 10 : 12,
                  mainAxisSpacing: isSmall ? 10 : 12,
                  childAspectRatio: isSmall ? 0.8 : 0.7,
                ),
                itemCount: newProducts.length,
                itemBuilder: (context, index) {
                  final product = newProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPageSimple(
                            product: product,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
