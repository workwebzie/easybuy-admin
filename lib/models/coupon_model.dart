import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  final String id;
  final String code;
  final double discountAmount;
  final bool isPercentage;
  final double minSpend;
  final int usageLimit;
  final int usageCount;
  final bool isActive;
  final DateTime expiryDate;

  CouponModel({
    required this.id,
    required this.code,
    required this.discountAmount,
    this.isPercentage = true,
    this.minSpend = 0.0,
    this.usageLimit = 500,
    this.usageCount = 0,
    this.isActive = true,
    required this.expiryDate,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parseDate(dynamic dateVal) {
      if (dateVal is Timestamp) return dateVal.toDate();
      if (dateVal is String) return DateTime.tryParse(dateVal) ?? DateTime.now();
      return DateTime.now().add(const Duration(days: 30));
    }

    return CouponModel(
      id: docId.isNotEmpty ? docId : (json['id'] ?? ''),
      code: (json['code'] ?? '').toString().toUpperCase(),
      discountAmount: (json['discountAmount'] ?? 0.0).toDouble(),
      isPercentage: json['isPercentage'] ?? true,
      minSpend: (json['minSpend'] ?? 0.0).toDouble(),
      usageLimit: (json['usageLimit'] ?? 500).toInt(),
      usageCount: (json['usageCount'] ?? 0).toInt(),
      isActive: json['isActive'] ?? true,
      expiryDate: parseDate(json['expiryDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discountAmount': discountAmount,
      'isPercentage': isPercentage,
      'minSpend': minSpend,
      'usageLimit': usageLimit,
      'usageCount': usageCount,
      'isActive': isActive,
      'expiryDate': expiryDate.toIso8601String(),
    };
  }
}
