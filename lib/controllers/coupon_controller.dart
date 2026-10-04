import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/coupon_model.dart';
import '../services/firebase_service.dart';
import '../config/initial_seed_data.dart';

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
    coupons.assignAll(InitialSeedData.defaultCoupons);

    _firebaseService.streamCoupons().listen((firestoreCoupons) {
      if (firestoreCoupons.isNotEmpty) {
        coupons.assignAll(firestoreCoupons);
      }
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);

    Future.delayed(const Duration(seconds: 1), () => isLoading.value = false);
  }

  Future<void> addCoupon(CouponModel coupon) async {
    coupons.add(coupon);
    await _firebaseService.addCoupon(coupon);
    Get.back();
    Get.snackbar(
      'Coupon Published 🎟️',
      'Promo code ${coupon.code} active now',
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
      'Promo code deleted',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
