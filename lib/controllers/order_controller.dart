import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';
import '../services/firebase_service.dart';

class OrderController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedStatusFilter = 'All'.obs;
  final RxString searchQuery = ''.obs;

  // New order alert banner tracker
  final Rxn<OrderModel> latestNewOrder = Rxn<OrderModel>();

  StreamSubscription? _orderSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadOrders();
  }

  void _loadOrders() {
    isLoading.value = true;
    orders.clear();

    _orderSubscription?.cancel();
    _orderSubscription = _firebaseService.streamOrders().listen((firestoreOrders) {
      if (orders.isNotEmpty && firestoreOrders.length > orders.length) {
        final newest = firestoreOrders.first;
        _triggerNewOrderAlert(newest);
      }
      orders.assignAll(firestoreOrders);
      isLoading.value = false;
    }, onError: (err) {
      debugPrint('Firestore order stream notice: $err');
      isLoading.value = false;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      isLoading.value = false;
    });
  }

  void _triggerNewOrderAlert(OrderModel newOrder) {
    latestNewOrder.value = newOrder;
    Get.snackbar(
      '🛍️ NEW ORDER RECEIVED!',
      '${newOrder.orderNumber} - ${newOrder.customerName} (AED ${newOrder.totalAmount.toStringAsFixed(2)})',
      backgroundColor: const Color(0xFFFEEE00),
      colorText: const Color(0xFF1A1A1A),
      duration: const Duration(seconds: 5),
      icon: const Icon(Icons.notifications_active, color: Color(0xFF1A1A1A), size: 28),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
    );
  }

  List<OrderModel> get filteredOrders {
    return orders.where((order) {
      final matchesSearch = order.orderNumber.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          order.customerName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          order.customerEmail.toLowerCase().contains(searchQuery.value.toLowerCase());

      final matchesStatus = selectedStatusFilter.value == 'All' || order.status == selectedStatusFilter.value;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  int get pendingOrdersCount => orders.where((o) => o.status == 'Pending').length;
  int get processingOrdersCount => orders.where((o) => o.status == 'Processing').length;
  int get shippedOrdersCount => orders.where((o) => o.status == 'Shipped').length;
  int get deliveredOrdersCount => orders.where((o) => o.status == 'Delivered').length;

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      int index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        orders[index] = orders[index].copyWith(status: newStatus);
        orders.refresh();
      }
      await _firebaseService.updateOrderStatus(orderId, newStatus);
      Get.snackbar(
        'Order Status Updated in Firebase 📦',
        'Order status updated in Firestore to "$newStatus"',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        icon: const Icon(Icons.local_shipping, color: Color(0xFFFEEE00)),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      debugPrint('Update order error: $e');
    }
  }

  // Simulate an incoming order from a customer app and write to Firestore
  Future<void> simulateCustomerOrder() async {
    final simulatedId = 'ord_${DateTime.now().millisecondsSinceEpoch}';
    final simulatedOrder = OrderModel(
      id: simulatedId,
      orderNumber: '#N-${(100000 + (DateTime.now().millisecondsSinceEpoch % 899999))}',
      customerId: 'usr_simulated',
      customerName: 'Rashid Al-Kaitoob',
      customerEmail: 'rashid.k@gmail.com',
      customerPhone: '+971 50 998 1122',
      items: [
        OrderItemModel(
          productId: 'prod_simulated',
          productName: 'Customer Order Item',
          productImage: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80',
          price: 299.00,
          quantity: 1,
        ),
      ],
      totalAmount: 299.00,
      subtotal: 299.00,
      shippingFee: 0.0,
      status: 'Pending',
      paymentMethod: 'Apple Pay',
      paymentStatus: 'Paid',
      deliveryAddress: 'Penthouse 32, Downtown Heights, Business Bay, Dubai',
      orderDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    orders.insert(0, simulatedOrder);
    _triggerNewOrderAlert(simulatedOrder);
    await _firebaseService.addOrder(simulatedOrder);
  }

  @override
  void onClose() {
    _orderSubscription?.cancel();
    super.onClose();
  }
}
