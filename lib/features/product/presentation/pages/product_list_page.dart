import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/product_card.dart';
import '../providers/product_provider.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});
  
  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productListControllerProvider.notifier).loadProducts();
    });
    
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(productListControllerProvider.notifier).loadProducts();
    }
  }
  
  void _handleSearch(String query) {
    if (query.isEmpty) {
      ref.read(productListControllerProvider.notifier).loadProducts(refresh: true);
    } else {
      ref.read(productListControllerProvider.notifier).searchProducts(query);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productState = ref.watch(productListControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.products),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _handleSearch,
              decoration: InputDecoration(
                hintText: AppStrings.search,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _handleSearch('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          
          // Products Grid
          Expanded(
            child: productState.products.isEmpty && !productState.isLoading
                ? EmptyState(
                    message: AppStrings.noProductsFound,
                    icon: Icons.shopping_bag_outlined,
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
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: productState.products.length +
                          (productState.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == productState.products.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: LoadingIndicator(),
                            ),
                          );
                        }
                        
                        final product = productState.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            context.push('${AppRoutes.products}/${product.id}');
                          },
                        );
                      },
                    ),
                  ),
          ),
          
          // Loading at bottom
          if (productState.isLoading && productState.products.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LoadingIndicator(),
            ),
        ],
      ),
    );
  }
}

