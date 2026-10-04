import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final double discountPercent;
  final String category;
  final String subCategory;
  final String brand;
  final int stock;
  final double rating;
  final int reviewCount;
  final bool isExpress; // Noon Express ⚡️ tag
  final bool isFeatured;
  final bool isActive;
  final List<String> images;
  final Map<String, dynamic> attributes; // e.g. color, size, warranty
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    this.discountPercent = 0.0,
    required this.category,
    this.subCategory = '',
    required this.brand,
    required this.stock,
    this.rating = 4.5,
    this.reviewCount = 12,
    this.isExpress = true,
    this.isFeatured = false,
    this.isActive = true,
    required this.images,
    this.attributes = const {},
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parseDate(dynamic dateVal) {
      if (dateVal is Timestamp) return dateVal.toDate();
      if (dateVal is String) return DateTime.tryParse(dateVal) ?? DateTime.now();
      return DateTime.now();
    }

    double calcDiscount(double price, double origPrice) {
      if (origPrice > price && origPrice > 0) {
        return (((origPrice - price) / origPrice) * 100).roundToDouble();
      }
      return 0.0;
    }

    double price = (json['price'] ?? 0.0).toDouble();
    double origPrice = (json['originalPrice'] ?? price).toDouble();

    return ProductModel(
      id: docId.isNotEmpty ? docId : (json['id'] ?? ''),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: price,
      originalPrice: origPrice,
      discountPercent: (json['discountPercent'] ?? calcDiscount(price, origPrice)).toDouble(),
      category: json['category'] ?? 'Electronics',
      subCategory: json['subCategory'] ?? '',
      brand: json['brand'] ?? 'Generic',
      stock: (json['stock'] ?? 0).toInt(),
      rating: (json['rating'] ?? 4.5).toDouble(),
      reviewCount: (json['reviewCount'] ?? 0).toInt(),
      isExpress: json['isExpress'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      isActive: json['isActive'] ?? true,
      images: List<String>.from(json['images'] ?? []),
      attributes: Map<String, dynamic>.from(json['attributes'] ?? {}),
      createdAt: parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercent': discountPercent,
      'category': category,
      'subCategory': subCategory,
      'brand': brand,
      'stock': stock,
      'rating': rating,
      'reviewCount': reviewCount,
      'isExpress': isExpress,
      'isFeatured': isFeatured,
      'isActive': isActive,
      'images': images,
      'attributes': attributes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ProductModel copyWith({
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    double? discountPercent,
    String? category,
    String? subCategory,
    String? brand,
    int? stock,
    double? rating,
    int? reviewCount,
    bool? isExpress,
    bool? isFeatured,
    bool? isActive,
    List<String>? images,
    Map<String, dynamic>? attributes,
  }) {
    return ProductModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      brand: brand ?? this.brand,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isExpress: isExpress ?? this.isExpress,
      isFeatured: isFeatured ?? this.isFeatured,
      isActive: isActive ?? this.isActive,
      images: images ?? this.images,
      attributes: attributes ?? this.attributes,
      createdAt: createdAt,
    );
  }
}
