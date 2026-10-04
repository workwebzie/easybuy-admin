import 'package:cloud_firestore/cloud_firestore.dart';

class MegaDealModel {
  final String id;
  final String title;
  final String subtitle;
  final String productId;
  final String productName;
  final String productImage;
  final double dealPrice;
  final double originalPrice;
  final double discountPercent;
  final DateTime endTime;
  final String badgeText;
  final bool isActive;
  final DateTime createdAt;

  MegaDealModel({
    required this.id,
    required this.title,
    this.subtitle = 'Limited time offer - grab before stock ends!',
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.dealPrice,
    required this.originalPrice,
    required this.discountPercent,
    required this.endTime,
    this.badgeText = 'MEGA DEAL OF THE DAY ⚡️',
    this.isActive = true,
    required this.createdAt,
  });

  factory MegaDealModel.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parseDate(dynamic dateVal) {
      if (dateVal is Timestamp) return dateVal.toDate();
      if (dateVal is String) return DateTime.tryParse(dateVal) ?? DateTime.now();
      return DateTime.now();
    }

    double deal = (json['dealPrice'] ?? json['price'] ?? 0.0).toDouble();
    double orig = (json['originalPrice'] ?? deal).toDouble();
    double discount = orig > deal && orig > 0
        ? (((orig - deal) / orig) * 100).roundToDouble()
        : (json['discountPercent'] ?? 0.0).toDouble();

    return MegaDealModel(
      id: docId.isNotEmpty ? docId : (json['id'] ?? ''),
      title: json['title'] ?? 'MEGA DEAL ⚡️',
      subtitle: json['subtitle'] ?? 'Limited time offer - grab before stock ends!',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? 'Product Deal',
      productImage: json['productImage'] ?? json['image'] ?? '',
      dealPrice: deal,
      originalPrice: orig,
      discountPercent: discount,
      endTime: parseDate(json['endTime']),
      badgeText: json['badgeText'] ?? 'MEGA DEAL OF THE DAY ⚡️',
      isActive: json['isActive'] ?? true,
      createdAt: parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'dealPrice': dealPrice,
      'originalPrice': originalPrice,
      'discountPercent': discountPercent,
      'endTime': endTime.toIso8601String(),
      'badgeText': badgeText,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MegaDealModel copyWith({
    String? title,
    String? subtitle,
    double? dealPrice,
    double? originalPrice,
    double? discountPercent,
    DateTime? endTime,
    String? badgeText,
    bool? isActive,
  }) {
    return MegaDealModel(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      productId: productId,
      productName: productName,
      productImage: productImage,
      dealPrice: dealPrice ?? this.dealPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      endTime: endTime ?? this.endTime,
      badgeText: badgeText ?? this.badgeText,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}
