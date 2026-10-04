import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';
import '../services/firebase_service.dart';
import '../config/initial_seed_data.dart';

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
    categories.assignAll(InitialSeedData.defaultCategories);

    _firebaseService.streamCategories().listen((firestoreCats) {
      if (firestoreCats.isNotEmpty) {
        categories.assignAll(firestoreCats);
      }
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);

    Future.delayed(const Duration(seconds: 1), () => isLoading.value = false);
  }

  Future<void> addCategory(CategoryModel category) async {
    categories.add(category);
    await _firebaseService.addCategory(category);
    Get.back();
    Get.snackbar(
      'Category Added 🏷️',
      '${category.name} added to catalog',
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
      'Category removed from catalog',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
