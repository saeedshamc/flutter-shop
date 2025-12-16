import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/category_model.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, CategoryModel>> getCategoryById(String id);
  Future<Either<Failure, String>> addCategory(CategoryModel category);
  Future<Either<Failure, void>> updateCategory(CategoryModel category);
  Future<Either<Failure, void>> deleteCategory(String id);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final FirebaseService _firebaseService;
  
  CategoryRepositoryImpl({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  
  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final snapshot = await _firebaseService.categoriesCollection
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();
      
      final categories = snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .toList();
      
      AppLogger.info('Fetched ${categories.length} categories');
      return Right(categories);
    } catch (e, stackTrace) {
      AppLogger.error('Get categories error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در دریافت دسته‌بندی‌ها'));
    }
  }
  
  @override
  Future<Either<Failure, CategoryModel>> getCategoryById(String id) async {
    try {
      final doc = await _firebaseService.categoriesCollection.doc(id).get();
      
      if (!doc.exists) {
        return const Left(NotFoundFailure(message: 'دسته‌بندی یافت نشد'));
      }
      
      final category = CategoryModel.fromFirestore(doc);
      return Right(category);
    } catch (e, stackTrace) {
      AppLogger.error('Get category by id error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در دریافت دسته‌بندی'));
    }
  }
  
  @override
  Future<Either<Failure, String>> addCategory(CategoryModel category) async {
    try {
      final docRef = await _firebaseService.categoriesCollection
          .add(category.toFirestore());
      
      AppLogger.info('Category added: ${docRef.id}');
      return Right(docRef.id);
    } catch (e, stackTrace) {
      AppLogger.error('Add category error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در افزودن دسته‌بندی'));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateCategory(CategoryModel category) async {
    try {
      await _firebaseService.categoriesCollection
          .doc(category.id)
          .update(category.toFirestore());
      
      AppLogger.info('Category updated: ${category.id}');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Update category error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در به‌روزرسانی دسته‌بندی'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteCategory(String id) async {
    try {
      await _firebaseService.categoriesCollection.doc(id).delete();
      
      AppLogger.info('Category deleted: $id');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Delete category error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در حذف دسته‌بندی'));
    }
  }
}

