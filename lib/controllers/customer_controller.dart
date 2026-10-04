import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../services/firebase_service.dart';

class CustomerController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final RxList<UserModel> customers = <UserModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  StreamSubscription? _usersSubscription;
  StreamSubscription? _ordersSubscription;

  List<UserModel> _firestoreUsers = [];
  List<OrderModel> _firestoreOrders = [];

  @override
  void onInit() {
    super.onInit();
    _loadCustomers();
  }

  void _loadCustomers() {
    isLoading.value = true;
    customers.clear();

    // Stream users collection
    _usersSubscription?.cancel();
    _usersSubscription = _firebaseService.streamUsers().listen((firestoreUsers) {
      _firestoreUsers = firestoreUsers;
      _mergeCustomers();
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);

    // Stream orders collection to extract active customer profiles
    _ordersSubscription?.cancel();
    _ordersSubscription = _firebaseService.streamOrders().listen((firestoreOrders) {
      _firestoreOrders = firestoreOrders;
      _mergeCustomers();
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);

    Future.delayed(const Duration(milliseconds: 600), () => isLoading.value = false);
  }

  void _mergeCustomers() {
    final Map<String, UserModel> customerMap = {};

    // 1. Add direct users from Firestore users collection
    for (var u in _firestoreUsers) {
      customerMap[u.email.toLowerCase()] = u;
    }

    // 2. Extract & aggregate customers from orders
    for (var order in _firestoreOrders) {
      if (order.customerEmail.isNotEmpty) {
        final key = order.customerEmail.toLowerCase();
        if (customerMap.containsKey(key)) {
          final existing = customerMap[key]!;
          customerMap[key] = UserModel(
            id: existing.id.isNotEmpty ? existing.id : order.customerId,
            name: existing.name.isNotEmpty ? existing.name : order.customerName,
            email: existing.email,
            phone: existing.phone.isNotEmpty ? existing.phone : order.customerPhone,
            avatarUrl: existing.avatarUrl,
            totalOrders: existing.totalOrders + 1,
            totalSpent: existing.totalSpent + order.totalAmount,
            isBlocked: existing.isBlocked,
            joinDate: existing.joinDate,
          );
        } else {
          customerMap[key] = UserModel(
            id: order.customerId.isNotEmpty ? order.customerId : 'usr_${order.customerEmail.hashCode}',
            name: order.customerName,
            email: order.customerEmail,
            phone: order.customerPhone,
            avatarUrl: '',
            totalOrders: 1,
            totalSpent: order.totalAmount,
            isBlocked: false,
            joinDate: order.orderDate,
          );
        }
      }
    }

    customers.assignAll(customerMap.values.toList());
  }

  List<UserModel> get filteredCustomers {
    return customers.where((c) {
      return c.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          c.email.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          c.phone.contains(searchQuery.value);
    }).toList();
  }

  Future<void> addCustomer(UserModel customer) async {
    if (!customers.any((c) => c.email.toLowerCase() == customer.email.toLowerCase())) {
      customers.add(customer);
    }
    // Save to users collection in Firestore
    final db = _firebaseService.firestore;
    if (db != null) {
      final docRef = db.collection('users').doc(customer.id);
      await docRef.set(customer.toJson());
    }
    Get.back();
    Get.snackbar(
      'Customer Saved to Firebase 👤',
      'Account created for ${customer.name}',
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> toggleBlockStatus(UserModel user) async {
    final newStatus = !user.isBlocked;
    int index = customers.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      customers[index] = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        avatarUrl: user.avatarUrl,
        totalOrders: user.totalOrders,
        totalSpent: user.totalSpent,
        isBlocked: newStatus,
        joinDate: user.joinDate,
      );
      customers.refresh();
    }

    await _firebaseService.toggleUserBlockStatus(user.id, newStatus);
    Get.snackbar(
      newStatus ? 'Customer Blocked 🚫' : 'Customer Unblocked ✅',
      'Account status updated in Firestore for ${user.name}',
      backgroundColor: newStatus ? Colors.redAccent : const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  void onClose() {
    _usersSubscription?.cancel();
    _ordersSubscription?.cancel();
    super.onClose();
  }
}
