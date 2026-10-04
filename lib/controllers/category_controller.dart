import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';
import '../services/firebase_service.dart';

class CategoryController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  void _loadCategories() {
    isLoading.value = true;
    categories.clear();

    _firebaseService.streamCategories().listen((firestoreCats) {
      categories.assignAll(firestoreCats);
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);

    Future.delayed(const Duration(milliseconds: 600), () => isLoading.value = false);
  }

  Future<void> addCategory(CategoryModel category) async {
    if (!categories.any((c) => c.id == category.id)) {
      categories.add(category);
    }
    await _firebaseService.addCategory(category);
    Get.back();
    Get.snackbar(
      'Category Saved to Firebase 🏷️',
      '${category.name} created in Firestore',
      backgroundColor: const Color(0xFF10B981),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> deleteCategory(String id) async {
    categories.removeWhere((c) => c.id == id);
    await _firebaseService.deleteCategory(id);
    Get.snackbar(
      'Category Removed',
      'Category deleted from Firestore',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
