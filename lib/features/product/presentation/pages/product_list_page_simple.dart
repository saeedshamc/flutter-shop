import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/data/mock_data.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../../../shared/widgets/empty_state.dart';
import 'product_detail_page_simple.dart';

class ProductListPageSimple extends StatefulWidget {
  final String? categoryId;
  final String? searchQuery;
  
  const ProductListPageSimple({
    super.key,
    this.categoryId,
    this.searchQuery,
  });
  
  @override
  State<ProductListPageSimple> createState() => _ProductListPageSimpleState();
}

class _ProductListPageSimpleState extends State<ProductListPageSimple> {
  final _searchController = TextEditingController();
  List<ProductModel> _products = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    if (widget.searchQuery != null) {
      _searchController.text = widget.searchQuery!;
    }
    _loadProducts();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _loadProducts() {
    setState(() => _isLoading = true);
    
    Future.delayed(const Duration(milliseconds: 500), () {
      List<ProductModel> products;
      
      if (widget.categoryId != null) {
        products = MockData.getProductsByCategory(widget.categoryId!);
      } else if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        products = MockData.getProducts().where((p) {
          return p.name.toLowerCase().contains(query) ||
                 p.brand.toLowerCase().contains(query) ||
                 p.description.toLowerCase().contains(query);
        }).toList();
      } else {
        products = MockData.getProducts();
      }
      
      setState(() {
        _products = products;
        _isLoading = false;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.products),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('فیلتر به زودی اضافه می‌شود')),
              );
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
              decoration: InputDecoration(
                hintText: AppStrings.search,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadProducts();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
                _loadProducts();
              },
            ),
          ),
          
          // Products Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? EmptyState(
                        message: AppStrings.noProductsFound,
                        icon: Icons.shopping_bag_outlined,
                        onRetry: _loadProducts,
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          _loadProducts();
                        },
                        child: GridView.builder(
                          padding: EdgeInsets.all(isSmall ? 12 : 16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isSmall ? 2 : 3,
                            crossAxisSpacing: isSmall ? 10 : 12,
                            mainAxisSpacing: isSmall ? 10 : 12,
                            childAspectRatio: isSmall ? 0.8 : 0.7,
                          ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            final product = _products[index];
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
                      ),
          ),
        ],
      ),
    );
  }
}
