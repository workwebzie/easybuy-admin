import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/banner_model.dart';
import '../services/firebase_service.dart';

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
    banners.clear();

    _firebaseService.streamBanners().listen((firestoreBanners) {
      banners.assignAll(firestoreBanners);
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);

    Future.delayed(const Duration(milliseconds: 600), () => isLoading.value = false);
  }

  Future<void> addBanner(BannerModel banner) async {
    if (!banners.any((b) => b.id == banner.id)) {
      banners.add(banner);
    }
    await _firebaseService.addBanner(banner);
    Get.back();
    Get.snackbar(
      'Banner Saved to Firebase 🖼️',
      'Promotional slider uploaded to Firestore',
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
      'Banner deleted from Firestore',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
