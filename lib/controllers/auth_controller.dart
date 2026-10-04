import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = true.obs; // Pre-authenticated for quick demo, toggleable
  final RxString adminEmail = 'admin@noon.com'.obs;
  final RxString adminName = 'EasyBuy Admin Team'.obs;
  final RxString adminRole = 'Super Admin'.obs;

  final emailController = TextEditingController(text: 'admin@noon.com');
  final passwordController = TextEditingController(text: 'admin12345');

  void login() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoggedIn.value = true;
      Get.snackbar(
        'Welcome Back! ⚡️',
        'Logged in successfully as Noon Administrator',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        icon: const Icon(Icons.verified, color: Color(0xFFFEEE00)),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Login Error',
        'Please enter valid admin credentials',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void logout() {
    isLoggedIn.value = false;
    Get.snackbar(
      'Logged Out',
      'You have been logged out of EasyBuy Admin Portal',
      backgroundColor: Colors.black87,
      colorText: Colors.white,
    );
  }
}
