import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/firebase_service.dart';

class ProductController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  // Search & Filters
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool onlyExpress = false.obs;
  final RxBool onlyLowStock = false.obs;

  StreamSubscription? _productSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadProducts();
  }

  void _loadProducts() {
    isLoading.value = true;
    products.clear();

    _productSubscription?.cancel();
    _productSubscription = _firebaseService.streamProducts().listen((firestoreProducts) {
      products.assignAll(firestoreProducts);
      isLoading.value = false;
    }, onError: (err) {
      debugPrint('Firestore product stream notice: $err');
      isLoading.value = false;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      isLoading.value = false;
    });
  }

  List<ProductModel> get filteredProducts {
    return products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          product.brand.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          product.category.toLowerCase().contains(searchQuery.value.toLowerCase());
      
      final matchesCategory = selectedCategory.value == 'All' || product.category == selectedCategory.value;
      final matchesExpress = !onlyExpress.value || product.isExpress;
      final matchesLowStock = !onlyLowStock.value || product.stock < 10;

      return matchesSearch && matchesCategory && matchesExpress && matchesLowStock;
    }).toList();
  }

  Future<void> addProduct(ProductModel newProduct) async {
    try {
      if (!products.any((p) => p.id == newProduct.id)) {
        products.insert(0, newProduct);
      }
      await _firebaseService.addProduct(newProduct);
      Get.back(); // Close modal
      Get.snackbar(
        'Product Saved to Firebase ⚡️',
        '${newProduct.name} saved in Firestore collection "products"',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      debugPrint('Add product error: $e');
    }
  }

  Future<void> updateProduct(ProductModel updatedProduct) async {
    try {
      int index = products.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        products[index] = updatedProduct;
        products.refresh();
      }
      await _firebaseService.updateProduct(updatedProduct);
      Get.back();
      Get.snackbar(
        'Product Updated in Firebase ✨',
        'Changes saved in Firestore',
        backgroundColor: const Color(0xFF3B82F6),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      debugPrint('Update product error: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      products.removeWhere((p) => p.id == productId);
      await _firebaseService.deleteProduct(productId);
      Get.snackbar(
        'Product Deleted',
        'Item deleted from Firestore collection "products"',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      debugPrint('Delete product error: $e');
    }
  }

  void toggleExpress(ProductModel product) {
    final updated = product.copyWith(isExpress: !product.isExpress);
    updateProduct(updated);
  }

  void toggleActive(ProductModel product) {
    final updated = product.copyWith(isActive: !product.isActive);
    updateProduct(updated);
  }

  @override
  void onClose() {
    _productSubscription?.cancel();
    super.onClose();
  }
}
