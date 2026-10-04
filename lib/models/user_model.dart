import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final int totalOrders;
  final double totalSpent;
  final bool isBlocked;
  final DateTime joinDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl = '',
    this.totalOrders = 0,
    this.totalSpent = 0.0,
    this.isBlocked = false,
    required this.joinDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parseDate(dynamic dateVal) {
      if (dateVal is Timestamp) return dateVal.toDate();
      if (dateVal is String) return DateTime.tryParse(dateVal) ?? DateTime.now();
      return DateTime.now();
    }

    return UserModel(
      id: docId.isNotEmpty ? docId : (json['id'] ?? ''),
      name: json['name'] ?? 'User',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      totalOrders: (json['totalOrders'] ?? 0).toInt(),
      totalSpent: (json['totalSpent'] ?? 0.0).toDouble(),
      isBlocked: json['isBlocked'] ?? false,
      joinDate: parseDate(json['joinDate'] ?? json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'isBlocked': isBlocked,
      'joinDate': joinDate.toIso8601String(),
    };
  }
}
