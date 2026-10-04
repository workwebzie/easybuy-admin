import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String id;
  final String title;
  final String imageUrl;
  final String targetCategory;
  final bool isActive;
  final int position;
  final DateTime createdAt;

  BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.targetCategory = 'All',
    this.isActive = true,
    this.position = 1,
    required this.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parseDate(dynamic dateVal) {
      if (dateVal is Timestamp) return dateVal.toDate();
      if (dateVal is String) return DateTime.tryParse(dateVal) ?? DateTime.now();
      return DateTime.now();
    }

    return BannerModel(
      id: docId.isNotEmpty ? docId : (json['id'] ?? ''),
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      targetCategory: json['targetCategory'] ?? 'All',
      isActive: json['isActive'] ?? true,
      position: (json['position'] ?? 1).toInt(),
      createdAt: parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'targetCategory': targetCategory,
      'isActive': isActive,
      'position': position,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
