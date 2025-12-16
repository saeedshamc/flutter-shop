import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/models/product_model.dart';
import '../../../../shared/models/filter_model.dart';
import '../../data/product_repository.dart';

// Product Repository Provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return getIt<ProductRepository>();
});

// Featured Products Provider
final featuredProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final result = await getIt<ProductRepository>().getFeaturedProducts();
  return result.fold(
    (failure) => [],
    (products) => products,
  );
});

// New Products Provider
final newProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final result = await getIt<ProductRepository>().getNewProducts();
  return result.fold(
    (failure) => [],
    (products) => products,
  );
});

// Product Details Provider
final productDetailsProvider = FutureProvider.family<ProductModel?, String>((ref, id) async {
  final result = await getIt<ProductRepository>().getProductById(id);
  return result.fold(
    (failure) => null,
    (product) => product,
  );
});

// Product List State
class ProductListState {
  final List<ProductModel> products;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final DocumentSnapshot? lastDocument;
  final FilterModel filter;
  
  ProductListState({
    this.products = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.lastDocument,
    this.filter = const FilterModel(),
  });
  
  ProductListState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    bool? hasMore,
    String? error,
    DocumentSnapshot? lastDocument,
    FilterModel? filter,
  }) {
    return ProductListState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      lastDocument: lastDocument ?? this.lastDocument,
      filter: filter ?? this.filter,
    );
  }
}

// Product List Controller
class ProductListController extends StateNotifier<ProductListState> {
  final ProductRepository _productRepository;
  
  ProductListController(this._productRepository) : super(ProductListState());
  
  Future<void> loadProducts({bool refresh = false}) async {
    if (state.isLoading) return;
    
    if (refresh) {
      state = ProductListState(filter: state.filter);
    }
    
    if (!state.hasMore && !refresh) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _productRepository.getProducts(
      limit: 20,
      lastDocument: refresh ? null : state.lastDocument,
      filter: state.filter,
    );
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (newProducts) {
        final allProducts = refresh
            ? newProducts
            : [...state.products, ...newProducts];
        
        state = state.copyWith(
          products: allProducts,
          isLoading: false,
          hasMore: newProducts.length == 20,
        );
      },
    );
  }
  
  Future<void> searchProducts(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _productRepository.searchProducts(query);
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (products) {
        state = state.copyWith(
          products: products,
          isLoading: false,
          hasMore: false,
        );
      },
    );
  }
  
  void applyFilter(FilterModel filter) {
    state = state.copyWith(filter: filter);
    loadProducts(refresh: true);
  }
  
  void clearFilter() {
    state = state.copyWith(filter: const FilterModel());
    loadProducts(refresh: true);
  }
}

// Product List Controller Provider
final productListControllerProvider = 
    StateNotifierProvider<ProductListController, ProductListState>((ref) {
  return ProductListController(ref.watch(productRepositoryProvider));
});

// Product CRUD Controller (for Admin)
class ProductCrudState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  
  ProductCrudState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });
  
  ProductCrudState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return ProductCrudState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

class ProductCrudController extends StateNotifier<ProductCrudState> {
  final ProductRepository _productRepository;
  
  ProductCrudController(this._productRepository) : super(ProductCrudState());
  
  Future<bool> addProduct(ProductModel product) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _productRepository.addProduct(product);
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (id) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'محصول با موفقیت اضافه شد',
        );
        return true;
      },
    );
  }
  
  Future<bool> updateProduct(ProductModel product) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _productRepository.updateProduct(product);
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'محصول با موفقیت به‌روزرسانی شد',
        );
        return true;
      },
    );
  }
  
  Future<bool> deleteProduct(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _productRepository.deleteProduct(id);
    
    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'محصول با موفقیت حذف شد',
        );
        return true;
      },
    );
  }
  
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

final productCrudControllerProvider = 
    StateNotifierProvider<ProductCrudController, ProductCrudState>((ref) {
  return ProductCrudController(ref.watch(productRepositoryProvider));
});

