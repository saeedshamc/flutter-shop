import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;
  
  CartItem({
    required this.product,
    this.quantity = 1,
  });
  
  double get totalPrice => product.finalPrice * quantity;
  
  CartItem copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartState {
  final List<CartItem> items;
  final bool isLoading;
  
  CartState({
    this.items = const [],
    this.isLoading = false,
  });
  
  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
  
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());
  
  void addItem(ProductModel product, int quantity) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );
    
    if (existingIndex >= 0) {
      final existingItem = state.items[existingIndex];
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(
        items: [...state.items, CartItem(product: product, quantity: quantity)],
      );
    }
  }
  
  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
  }
  
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }
    
    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    
    state = state.copyWith(items: updatedItems);
  }
  
  void clearCart() {
    state = CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

