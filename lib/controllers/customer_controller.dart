import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../config/initial_seed_data.dart';

class CustomerController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final RxList<UserModel> customers = <UserModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCustomers();
  }

  void _loadCustomers() {
    isLoading.value = true;
    customers.assignAll(InitialSeedData.defaultUsers);

    _firebaseService.streamUsers().listen((firestoreUsers) {
      if (firestoreUsers.isNotEmpty) {
        customers.assignAll(firestoreUsers);
      }
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);

    Future.delayed(const Duration(seconds: 1), () => isLoading.value = false);
  }

  List<UserModel> get filteredCustomers {
    return customers.where((c) {
      return c.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          c.email.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          c.phone.contains(searchQuery.value);
    }).toList();
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
      'Account status updated for ${user.name}',
      backgroundColor: newStatus ? Colors.redAccent : const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
