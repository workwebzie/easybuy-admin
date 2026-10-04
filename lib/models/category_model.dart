import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final String bannerUrl;
  final int productCount;
  final bool isFeatured;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    this.bannerUrl = '',
    this.productCount = 0,
    this.isFeatured = true,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parseDate(dynamic dateVal) {
      if (dateVal is Timestamp) return dateVal.toDate();
      if (dateVal is String) return DateTime.tryParse(dateVal) ?? DateTime.now();
      return DateTime.now();
    }

    return CategoryModel(
      id: docId.isNotEmpty ? docId : (json['id'] ?? ''),
      name: json['name'] ?? '',
      icon: json['icon'] ?? '📱',
      bannerUrl: json['bannerUrl'] ?? '',
      productCount: (json['productCount'] ?? 0).toInt(),
      isFeatured: json['isFeatured'] ?? true,
      createdAt: parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'bannerUrl': bannerUrl,
      'productCount': productCount,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
