import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/mega_deal_model.dart';
import '../services/firebase_service.dart';

class MegaDealController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final RxList<MegaDealModel> megaDeals = <MegaDealModel>[].obs;
  final RxBool isLoading = false.obs;

  StreamSubscription? _dealSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadMegaDeals();
  }

  void _loadMegaDeals() {
    isLoading.value = true;
    megaDeals.clear();

    _dealSubscription?.cancel();
    _dealSubscription = _firebaseService.streamMegaDeals().listen((firestoreDeals) {
      megaDeals.assignAll(firestoreDeals);
      isLoading.value = false;
    }, onError: (err) {
      debugPrint('Firestore mega_deals stream error: $err');
      isLoading.value = false;
    });

    Future.delayed(const Duration(milliseconds: 600), () => isLoading.value = false);
  }

  Future<void> addMegaDeal(MegaDealModel deal) async {
    if (!megaDeals.any((d) => d.id == deal.id)) {
      megaDeals.add(deal);
    }
    await _firebaseService.addMegaDeal(deal);
    Get.back();
    Get.snackbar(
      'Mega Deal Published ⚡️',
      'Deal "${deal.title}" active in Firestore collection "mega_deals"',
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> updateMegaDeal(MegaDealModel deal) async {
    int index = megaDeals.indexWhere((d) => d.id == deal.id);
    if (index != -1) {
      megaDeals[index] = deal;
      megaDeals.refresh();
    }
    await _firebaseService.updateMegaDeal(deal);
    Get.snackbar(
      'Mega Deal Updated ✨',
      'Changes saved to Firestore',
      backgroundColor: const Color(0xFF3B82F6),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> deleteMegaDeal(String id) async {
    megaDeals.removeWhere((d) => d.id == id);
    await _firebaseService.deleteMegaDeal(id);
    Get.snackbar(
      'Mega Deal Removed',
      'Deal removed from Firestore',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  void toggleActive(MegaDealModel deal) {
    final updated = deal.copyWith(isActive: !deal.isActive);
    updateMegaDeal(updated);
  }

  @override
  void onClose() {
    _dealSubscription?.cancel();
    super.onClose();
  }
}
