import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/coupon_model.dart';
import '../services/firebase_service.dart';

class CouponController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final RxList<CouponModel> coupons = <CouponModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCoupons();
  }

  void _loadCoupons() {
    isLoading.value = true;
    coupons.clear();

    _firebaseService.streamCoupons().listen((firestoreCoupons) {
      coupons.assignAll(firestoreCoupons);
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);

    Future.delayed(const Duration(milliseconds: 600), () => isLoading.value = false);
  }

  Future<void> addCoupon(CouponModel coupon) async {
    if (!coupons.any((c) => c.id == coupon.id)) {
      coupons.add(coupon);
    }
    await _firebaseService.addCoupon(coupon);
    Get.back();
    Get.snackbar(
      'Coupon Saved to Firebase 🎟️',
      'Promo code ${coupon.code} active in Firestore',
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> deleteCoupon(String id) async {
    coupons.removeWhere((c) => c.id == id);
    await _firebaseService.deleteCoupon(id);
    Get.snackbar(
      'Coupon Removed',
      'Promo code deleted from Firestore',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
