import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/models/filter_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts({
    int? limit,
    DocumentSnapshot? lastDocument,
    FilterModel? filter,
  });
  Future<Either<Failure, ProductModel>> getProductById(String id);
  Future<Either<Failure, List<ProductModel>>> getFeaturedProducts({int limit = 10});
  Future<Either<Failure, List<ProductModel>>> getNewProducts({int limit = 10});
  Future<Either<Failure, List<ProductModel>>> searchProducts(String query);
  Future<Either<Failure, String>> addProduct(ProductModel product);
  Future<Either<Failure, void>> updateProduct(ProductModel product);
  Future<Either<Failure, void>> deleteProduct(String id);
}

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseService _firebaseService;
  
  ProductRepositoryImpl({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  
  @override
  Future<Either<Failure, List<ProductModel>>> getProducts({
    int? limit,
    DocumentSnapshot? lastDocument,
    FilterModel? filter,
  }) async {
    try {
      Query query = _firebaseService.productsCollection
          .where('isActive', isEqualTo: true);
      
      // Apply filters
      if (filter != null) {
        if (filter.categoryId != null) {
          query = query.where('categoryId', isEqualTo: filter.categoryId);
        }
        
        if (filter.brand != null) {
          query = query.where('brand', isEqualTo: filter.brand);
        }
        
        if (filter.minPrice != null) {
          query = query.where('price', isGreaterThanOrEqualTo: filter.minPrice);
        }
        
        if (filter.maxPrice != null) {
          query = query.where('price', isLessThanOrEqualTo: filter.maxPrice);
        }
        
        // Apply sorting
        switch (filter.sortBy) {
          case SortBy.newest:
            query = query.orderBy('createdAt', descending: true);
            break;
          case SortBy.cheapest:
            query = query.orderBy('price', descending: false);
            break;
          case SortBy.mostExpensive:
            query = query.orderBy('price', descending: true);
            break;
          case SortBy.bestRating:
            query = query.orderBy('rating', descending: true);
            break;
        }
      } else {
        query = query.orderBy('createdAt', descending: true);
      }
      
      // Pagination
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      
      AppLogger.info('Fetched ${products.length} products');
      return Right(products);
    } catch (e, stackTrace) {
      AppLogger.error('Get products error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در دریافت محصولات'));
    }
  }
  
  @override
  Future<Either<Failure, ProductModel>> getProductById(String id) async {
    try {
      final doc = await _firebaseService.productsCollection.doc(id).get();
      
      if (!doc.exists) {
        return const Left(NotFoundFailure(message: 'محصول یافت نشد'));
      }
      
      final product = ProductModel.fromFirestore(doc);
      return Right(product);
    } catch (e, stackTrace) {
      AppLogger.error('Get product by id error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در دریافت محصول'));
    }
  }
  
  @override
  Future<Either<Failure, List<ProductModel>>> getFeaturedProducts({
    int limit = 10,
  }) async {
    try {
      final snapshot = await _firebaseService.productsCollection
          .where('isActive', isEqualTo: true)
          .where('isFeatured', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      
      return Right(products);
    } catch (e, stackTrace) {
      AppLogger.error('Get featured products error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در دریافت محصولات ویژه'));
    }
  }
  
  @override
  Future<Either<Failure, List<ProductModel>>> getNewProducts({
    int limit = 10,
  }) async {
    try {
      final snapshot = await _firebaseService.productsCollection
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      
      return Right(products);
    } catch (e, stackTrace) {
      AppLogger.error('Get new products error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در دریافت محصولات جدید'));
    }
  }
  
  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts(String query) async {
    try {
      // Note: Firestore doesn't support full-text search out of the box
      // For production, consider using Algolia or ElasticSearch
      // This is a basic implementation using name field
      
      final snapshot = await _firebaseService.productsCollection
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .get();
      
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      
      return Right(products);
    } catch (e, stackTrace) {
      AppLogger.error('Search products error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در جستجوی محصولات'));
    }
  }
  
  @override
  Future<Either<Failure, String>> addProduct(ProductModel product) async {
    try {
      final docRef = await _firebaseService.productsCollection
          .add(product.toFirestore());
      
      AppLogger.info('Product added: ${docRef.id}');
      return Right(docRef.id);
    } catch (e, stackTrace) {
      AppLogger.error('Add product error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در افزودن محصول'));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateProduct(ProductModel product) async {
    try {
      await _firebaseService.productsCollection
          .doc(product.id)
          .update(product.toFirestore());
      
      AppLogger.info('Product updated: ${product.id}');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Update product error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در به‌روزرسانی محصول'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _firebaseService.productsCollection.doc(id).delete();
      
      AppLogger.info('Product deleted: $id');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Delete product error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در حذف محصول'));
    }
  }
}

