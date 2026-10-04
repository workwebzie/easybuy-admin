import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItemModel {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String variant;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.variant = '',
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? json['name'] ?? 'Product',
      productImage: json['productImage'] ?? json['image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: (json['quantity'] ?? 1).toInt(),
      variant: json['variant'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'variant': variant,
    };
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final List<OrderItemModel> items;
  final double totalAmount;
  final double subtotal;
  final double shippingFee;
  final double discountAmount;
  final String status; // Pending, Processing, Shipped, Out for Delivery, Delivered, Cancelled
  final String paymentMethod;
  final String paymentStatus; // Paid, Pending, Failed
  final String deliveryAddress;
  final DateTime orderDate;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.items,
    required this.totalAmount,
    required this.subtotal,
    this.shippingFee = 0.0,
    this.discountAmount = 0.0,
    this.status = 'Pending',
    this.paymentMethod = 'Credit Card',
    this.paymentStatus = 'Paid',
    required this.deliveryAddress,
    required this.orderDate,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String docId) {
    DateTime parseDate(dynamic dateVal) {
      if (dateVal is Timestamp) return dateVal.toDate();
      if (dateVal is String) return DateTime.tryParse(dateVal) ?? DateTime.now();
      return DateTime.now();
    }

    var itemsList = <OrderItemModel>[];
    if (json['items'] is List) {
      itemsList = (json['items'] as List)
          .map((i) => OrderItemModel.fromJson(Map<String, dynamic>.from(i)))
          .toList();
    }

    return OrderModel(
      id: docId.isNotEmpty ? docId : (json['id'] ?? ''),
      orderNumber: json['orderNumber'] ?? '#N-${docId.takeLast(6).toUpperCase()}',
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? json['user']?['name'] ?? 'Customer',
      customerEmail: json['customerEmail'] ?? json['user']?['email'] ?? '',
      customerPhone: json['customerPhone'] ?? json['user']?['phone'] ?? '+971 50 123 4567',
      items: itemsList,
      totalAmount: (json['totalAmount'] ?? json['total'] ?? 0.0).toDouble(),
      subtotal: (json['subtotal'] ?? json['totalAmount'] ?? 0.0).toDouble(),
      shippingFee: (json['shippingFee'] ?? 0.0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'Pending',
      paymentMethod: json['paymentMethod'] ?? 'Credit Card',
      paymentStatus: json['paymentStatus'] ?? 'Paid',
      deliveryAddress: json['deliveryAddress'] is String
          ? json['deliveryAddress']
          : (json['deliveryAddress']?['formatted'] ?? 'Dubai Downtown, UAE'),
      orderDate: parseDate(json['orderDate'] ?? json['createdAt']),
      updatedAt: parseDate(json['updatedAt'] ?? json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'items': items.map((i) => i.toJson()).toList(),
      'totalAmount': totalAmount,
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'discountAmount': discountAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'deliveryAddress': deliveryAddress,
      'orderDate': orderDate.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? status,
    String? paymentStatus,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id,
      orderNumber: orderNumber,
      customerId: customerId,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      items: items,
      totalAmount: totalAmount,
      subtotal: subtotal,
      shippingFee: shippingFee,
      discountAmount: discountAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      deliveryAddress: deliveryAddress,
      orderDate: orderDate,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

extension StringExtension on String {
  String takeLast(int n) {
    if (length <= n) return this;
    return substring(length - n);
  }
}
