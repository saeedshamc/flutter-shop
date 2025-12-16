import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/logger.dart';
import '../../../shared/models/order_model.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderModel>>> getOrders({String? userId});
  Future<Either<Failure, OrderModel>> getOrderById(String id);
  Future<Either<Failure, String>> createOrder(OrderModel order);
  Future<Either<Failure, void>> updateOrderStatus(String id, OrderStatus status);
  Future<Either<Failure, void>> cancelOrder(String id);
}

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseService _firebaseService;
  
  OrderRepositoryImpl({required FirebaseService firebaseService})
      : _firebaseService = firebaseService;
  
  @override
  Future<Either<Failure, List<OrderModel>>> getOrders({String? userId}) async {
    try {
      var query = _firebaseService.ordersCollection
          .orderBy('createdAt', descending: true);
      
      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }
      
      final snapshot = await query.get();
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
      
      AppLogger.info('Fetched ${orders.length} orders');
      return Right(orders);
    } catch (e, stackTrace) {
      AppLogger.error('Get orders error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در دریافت سفارش‌ها'));
    }
  }
  
  @override
  Future<Either<Failure, OrderModel>> getOrderById(String id) async {
    try {
      final doc = await _firebaseService.ordersCollection.doc(id).get();
      
      if (!doc.exists) {
        return const Left(NotFoundFailure(message: 'سفارش یافت نشد'));
      }
      
      final order = OrderModel.fromFirestore(doc);
      return Right(order);
    } catch (e, stackTrace) {
      AppLogger.error('Get order by id error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در دریافت سفارش'));
    }
  }
  
  @override
  Future<Either<Failure, String>> createOrder(OrderModel order) async {
    try {
      final docRef = await _firebaseService.ordersCollection
          .add(order.toFirestore());
      
      AppLogger.info('Order created: ${docRef.id}');
      return Right(docRef.id);
    } catch (e, stackTrace) {
      AppLogger.error('Create order error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در ایجاد سفارش'));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateOrderStatus(
    String id,
    OrderStatus status,
  ) async {
    try {
      await _firebaseService.ordersCollection.doc(id).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      AppLogger.info('Order status updated: $id -> ${status.name}');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Update order status error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در به‌روزرسانی وضعیت سفارش'));
    }
  }
  
  @override
  Future<Either<Failure, void>> cancelOrder(String id) async {
    try {
      await _firebaseService.ordersCollection.doc(id).update({
        'status': OrderStatus.cancelled.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      AppLogger.info('Order cancelled: $id');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Cancel order error', e, stackTrace);
      return const Left(ServerFailure(message: 'خطا در لغو سفارش'));
    }
  }
}

