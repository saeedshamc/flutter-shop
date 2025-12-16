import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();
  
  const factory ProductModel({
    required String id,
    required String name,
    required String brand,
    required String description,
    required double price,
    @Default(0) double discount,
    required String categoryId,
    String? categoryName,
    @Default([]) List<String> images,
    @Default(0) int stock,
    @Default(0) double rating,
    @Default(0) int reviewCount,
    @Default(true) bool isActive,
    @Default(false) bool isFeatured,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ProductModel;
  
  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
  
  // From Firestore
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'],
      images: List<String>.from(data['images'] ?? []),
      stock: data['stock'] ?? 0,
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      isActive: data['isActive'] ?? true,
      isFeatured: data['isFeatured'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
  
  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'brand': brand,
      'description': description,
      'price': price,
      'discount': discount,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'images': images,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
  
  // Calculate final price after discount
  double get finalPrice => price - (price * discount / 100);
  
  // Check if product is in stock
  bool get inStock => stock > 0;
  
  // Check if product has discount
  bool get hasDiscount => discount > 0;
  
  // Get first image or placeholder
  String get primaryImage => images.isNotEmpty ? images.first : '';
}

