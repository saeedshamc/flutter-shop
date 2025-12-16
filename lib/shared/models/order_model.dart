import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

enum OrderStatus { pending, processing, completed, cancelled }

@freezed
class OrderItemModel with _$OrderItemModel {
  const OrderItemModel._();
  
  const factory OrderItemModel({
    required String productId,
    required String productName,
    required String productImage,
    required int quantity,
    required double price,
    @Default(0) double discount,
  }) = _OrderItemModel;
  
  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
  
  double get totalPrice => (price - (price * discount / 100)) * quantity;
}

@freezed
class ShippingAddressModel with _$ShippingAddressModel {
  const factory ShippingAddressModel({
    required String fullName,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String postalCode,
  }) = _ShippingAddressModel;
  
  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) => _$ShippingAddressModelFromJson(json);
}

@freezed
class OrderModel with _$OrderModel {
  const OrderModel._();
  
  const factory OrderModel({
    required String id,
    required String userId,
    required List<OrderItemModel> items,
    required double totalPrice,
    @Default(OrderStatus.pending) OrderStatus status,
    required String paymentMethod,
    required ShippingAddressModel shippingAddress,
    String? trackingNumber,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _OrderModel;
  
  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  
  // From Firestore
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>?)
          ?.map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: data['paymentMethod'] ?? '',
      shippingAddress: ShippingAddressModel.fromJson(
        data['shippingAddress'] as Map<String, dynamic>,
      ),
      trackingNumber: data['trackingNumber'],
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
  
  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'status': status.name,
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress.toJson(),
      'trackingNumber': trackingNumber,
      'notes': notes,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
  
  // Get total item count
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

