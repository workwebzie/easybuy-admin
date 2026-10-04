import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/banner_model.dart';
import '../services/firebase_service.dart';
import '../config/initial_seed_data.dart';

class BannerController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBanners();
  }

  void _loadBanners() {
    isLoading.value = true;
    banners.assignAll(InitialSeedData.defaultBanners);

    _firebaseService.streamBanners().listen((firestoreBanners) {
      if (firestoreBanners.isNotEmpty) {
        banners.assignAll(firestoreBanners);
      }
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);

    Future.delayed(const Duration(seconds: 1), () => isLoading.value = false);
  }

  Future<void> addBanner(BannerModel banner) async {
    banners.add(banner);
    await _firebaseService.addBanner(banner);
    Get.back();
    Get.snackbar(
      'Banner Created 🖼️',
      'Promotional slider updated in Noon mobile app',
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> deleteBanner(String id) async {
    banners.removeWhere((b) => b.id == id);
    await _firebaseService.deleteBanner(id);
    Get.snackbar(
      'Banner Removed',
      'Banner deleted from home carousel',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
