import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon_admin/firebase_options.dart';

import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import '../models/banner_model.dart';
import '../models/coupon_model.dart';
import '../models/mega_deal_model.dart';

class FirebaseService extends GetxService {
  final RxBool isFirebaseInitialized = false.obs;
  final RxString lastError = ''.obs;

  FirebaseFirestore? get firestore {
    if (isFirebaseInitialized.value) {
      try {
        return FirebaseFirestore.instance;
      } catch (e) {
        debugPrint('Firestore instance access error: $e');
        return null;
      }
    }
    return null;
  }

  Future<FirebaseService> init() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      isFirebaseInitialized.value = true;
      debugPrint('⚡️ Firebase initialized successfully on project: ${DefaultFirebaseOptions.currentPlatform.projectId}');
    } catch (e) {
      debugPrint('⚠️ Firebase setup notice: $e');
      lastError.value = e.toString();
      isFirebaseInitialized.value = false;
    }
    return this;
  }

  // ------------ PRODUCTS ------------
  Stream<List<ProductModel>> streamProducts() {
    final db = firestore;
    if (db != null) {
      return db
          .collection('products')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
              .toList())
          .handleError((error) {
        debugPrint('Firestore products stream error: $error');
        lastError.value = error.toString();
      });
    }
    return const Stream.empty();
  }

  Future<bool> addProduct(ProductModel product) async {
    final db = firestore;
    if (db != null) {
      try {
        final docRef = db.collection('products').doc();
        final newProduct = product.copyWith();
        await docRef.set(newProduct.toJson()..['id'] = docRef.id);
        return true;
      } catch (e) {
        debugPrint('Firestore addProduct Error: $e');
        _showFirebaseErrorToast('Failed to add product to Firebase', e);
        return false;
      }
    }
    return false;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final db = firestore;
    if (db != null) {
      try {
        await db.collection('products').doc(product.id).update(product.toJson());
        return true;
      } catch (e) {
        debugPrint('Firestore updateProduct Error: $e');
        _showFirebaseErrorToast('Failed to update product in Firebase', e);
        return false;
      }
    }
    return false;
  }

  Future<bool> deleteProduct(String productId) async {
    final db = firestore;
    if (db != null) {
      try {
        await db.collection('products').doc(productId).delete();
        return true;
      } catch (e) {
        debugPrint('Firestore deleteProduct Error: $e');
        _showFirebaseErrorToast('Failed to delete product from Firebase', e);
        return false;
      }
    }
    return false;
  }

  // ------------ ORDERS ------------
  Stream<List<OrderModel>> streamOrders() {
    final db = firestore;
    if (db != null) {
      return db
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
              .toList())
          .handleError((error) {
        debugPrint('Firestore orders stream error: $error');
        lastError.value = error.toString();
      });
    }
    return const Stream.empty();
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    final db = firestore;
    if (db != null) {
      try {
        await db.collection('orders').doc(orderId).update({
          'status': newStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return true;
      } catch (e) {
        debugPrint('Firestore updateOrderStatus Error: $e');
        _showFirebaseErrorToast('Failed to update order status in Firebase', e);
        return false;
      }
    }
    return false;
  }

  Future<bool> addOrder(OrderModel order) async {
    final db = firestore;
    if (db != null) {
      try {
        final docRef = db.collection('orders').doc();
        await docRef.set(order.toJson()..['id'] = docRef.id);
        return true;
      } catch (e) {
        debugPrint('Firestore addOrder Error: $e');
        _showFirebaseErrorToast('Failed to save order to Firebase', e);
        return false;
      }
    }
    return false;
  }

  // ------------ CATEGORIES ------------
  Stream<List<CategoryModel>> streamCategories() {
    final db = firestore;
    if (db != null) {
      return db
          .collection('categories')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromJson(doc.data(), doc.id))
              .toList())
          .handleError((error) {
        debugPrint('Firestore categories stream error: $error');
        lastError.value = error.toString();
      });
    }
    return const Stream.empty();
  }

  Future<bool> addCategory(CategoryModel category) async {
    final db = firestore;
    if (db != null) {
      try {
        final docRef = db.collection('categories').doc();
        await docRef.set(category.toJson()..['id'] = docRef.id);
        return true;
      } catch (e) {
        debugPrint('Firestore addCategory Error: $e');
        _showFirebaseErrorToast('Failed to add category to Firebase', e);
        return false;
      }
    }
    return false;
  }

  Future<bool> deleteCategory(String id) async {
    final db = firestore;
    if (db != null) {
      try {
        await db.collection('categories').doc(id).delete();
        return true;
      } catch (e) {
        debugPrint('Firestore deleteCategory Error: $e');
        _showFirebaseErrorToast('Failed to delete category in Firebase', e);
        return false;
      }
    }
    return false;
  }

  // ------------ BANNERS ------------
  Stream<List<BannerModel>> streamBanners() {
    final db = firestore;
    if (db != null) {
      return db
          .collection('banners')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => BannerModel.fromJson(doc.data(), doc.id))
              .toList())
          .handleError((error) {
        debugPrint('Firestore banners stream error: $error');
        lastError.value = error.toString();
      });
    }
    return const Stream.empty();
  }

  Future<bool> addBanner(BannerModel banner) async {
    final db = firestore;
    if (db != null) {
      try {
        final docRef = db.collection('banners').doc();
        await docRef.set(banner.toJson()..['id'] = docRef.id);
        return true;
      } catch (e) {
        debugPrint('Firestore addBanner Error: $e');
        _showFirebaseErrorToast('Failed to publish banner to Firebase', e);
        return false;
      }
    }
    return false;
  }

  Future<bool> deleteBanner(String id) async {
    final db = firestore;
    if (db != null) {
      try {
        await db.collection('banners').doc(id).delete();
        return true;
      } catch (e) {
        debugPrint('Firestore deleteBanner Error: $e');
        _showFirebaseErrorToast('Failed to delete banner from Firebase', e);
        return false;
      }
    }
    return false;
  }

  // ------------ USERS ------------
  Stream<List<UserModel>> streamUsers() {
    final db = firestore;
    if (db != null) {
      return db
          .collection('users')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => UserModel.fromJson(doc.data(), doc.id))
              .toList())
          .handleError((error) {
        debugPrint('Firestore users stream error: $error');
        lastError.value = error.toString();
      });
    }
    return const Stream.empty();
  }

  Future<bool> toggleUserBlockStatus(String userId, bool isBlocked) async {
    final db = firestore;
    if (db != null) {
      try {
        await db.collection('users').doc(userId).update({'isBlocked': isBlocked});
        return true;
      } catch (e) {
        debugPrint('Firestore toggleUserBlockStatus Error: $e');
        _showFirebaseErrorToast('Failed to update user status in Firebase', e);
        return false;
      }
    }
    return false;
  }

  // ------------ COUPONS ------------
  Stream<List<CouponModel>> streamCoupons() {
    final db = firestore;
    if (db != null) {
      return db
          .collection('coupons')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => CouponModel.fromJson(doc.data(), doc.id))
              .toList())
          .handleError((error) {
        debugPrint('Firestore coupons stream error: $error');
        lastError.value = error.toString();
      });
    }
    return const Stream.empty();
  }

  Future<bool> addCoupon(CouponModel coupon) async {
    final db = firestore;
    if (db != null) {
      try {
        final docRef = db.collection('coupons').doc();
        await docRef.set(coupon.toJson()..['id'] = docRef.id);
        return true;
      } catch (e) {
        debugPrint('Firestore addCoupon Error: $e');
        _showFirebaseErrorToast('Failed to add coupon to Firebase', e);
        return false;
      }
    }
    return false;
  }

  Future<bool> deleteCoupon(String id) async {
    final db = firestore;
    if (db != null) {
      try {
        await db.collection('coupons').doc(id).delete();
        return true;
      } catch (e) {
        debugPrint('Firestore deleteCoupon Error: $e');
        _showFirebaseErrorToast('Failed to delete coupon in Firebase', e);
        return false;
      }
    }
    return false;
  }

  // ------------ MEGA DEALS ------------
  Stream<List<MegaDealModel>> streamMegaDeals() {
    final db = firestore;
    if (db != null) {
      return db
          .collection('mega_deals')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => MegaDealModel.fromJson(doc.data(), doc.id))
              .toList())
          .handleError((error) {
        debugPrint('Firestore mega_deals stream error: $error');
        lastError.value = error.toString();
      });
    }
    return const Stream.empty();
  }

  Future<bool> addMegaDeal(MegaDealModel deal) async {
    final db = firestore;
    if (db != null) {
      try {
        final docRef = db.collection('mega_deals').doc();
        await docRef.set(deal.toJson()..['id'] = docRef.id);
        return true;
      } catch (e) {
        debugPrint('Firestore addMegaDeal Error: $e');
        _showFirebaseErrorToast('Failed to add Mega Deal to Firebase', e);
        return false;
      }
    }
    return false;
  }

  Future<bool> updateMegaDeal(MegaDealModel deal) async {
    final db = firestore;
    if (db != null) {
      try {
        await db.collection('mega_deals').doc(deal.id).update(deal.toJson());
        return true;
      } catch (e) {
        debugPrint('Firestore updateMegaDeal Error: $e');
        _showFirebaseErrorToast('Failed to update Mega Deal in Firebase', e);
        return false;
      }
    }
    return false;
  }

  Future<bool> deleteMegaDeal(String id) async {
    final db = firestore;
    if (db != null) {
      try {
        await db.collection('mega_deals').doc(id).delete();
        return true;
      } catch (e) {
        debugPrint('Firestore deleteMegaDeal Error: $e');
        _showFirebaseErrorToast('Failed to delete Mega Deal in Firebase', e);
        return false;
      }
    }
    return false;
  }

  void _showFirebaseErrorToast(String message, dynamic error) {
    String detail = error.toString();
    if (detail.contains('permission-denied')) {
      detail = 'Firebase Rules Permission Denied! Enable read/write in Firebase Console Firestore Rules.';
    }
    Get.snackbar(
      '⚠️ Firebase Connection Notice',
      '$message\n$detail',
      backgroundColor: Colors.red.shade900,
      colorText: Colors.white,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
    );
  }
}
