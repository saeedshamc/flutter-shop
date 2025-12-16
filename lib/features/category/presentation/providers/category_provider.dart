import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../../shared/models/category_model.dart';
import '../../data/category_repository.dart';

// Category Repository Provider
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return getIt<CategoryRepository>();
});

// Categories Provider
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final result = await getIt<CategoryRepository>().getCategories();
  return result.fold(
    (failure) => [],
    (categories) => categories,
  );
});

// Category Details Provider
final categoryDetailsProvider = FutureProvider.family<CategoryModel?, String>((ref, id) async {
  final result = await getIt<CategoryRepository>().getCategoryById(id);
  return result.fold(
    (failure) => null,
    (category) => category,
  );
});

// Category CRUD State
class CategoryCrudState {
  final bool isLoading;
  final String? error;
  final String? successMessage;
  
  CategoryCrudState({
    this.isLoading = false,
    this.error,
    this.successMessage,
  });
  
  CategoryCrudState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return CategoryCrudState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

// Category CRUD Controller
class CategoryCrudController extends StateNotifier<CategoryCrudState> {
  final CategoryRepository _categoryRepository;
  
  CategoryCrudController(this._categoryRepository) : super(CategoryCrudState());
  
  Future<bool> addCategory(CategoryModel category) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _categoryRepository.addCategory(category);
    
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
          successMessage: 'دسته‌بندی با موفقیت اضافه شد',
        );
        return true;
      },
    );
  }
  
  Future<bool> updateCategory(CategoryModel category) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _categoryRepository.updateCategory(category);
    
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
          successMessage: 'دسته‌بندی با موفقیت به‌روزرسانی شد',
        );
        return true;
      },
    );
  }
  
  Future<bool> deleteCategory(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _categoryRepository.deleteCategory(id);
    
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
          successMessage: 'دسته‌بندی با موفقیت حذف شد',
        );
        return true;
      },
    );
  }
  
  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

final categoryCrudControllerProvider = 
    StateNotifierProvider<CategoryCrudController, CategoryCrudState>((ref) {
  return CategoryCrudController(ref.watch(categoryRepositoryProvider));
});

