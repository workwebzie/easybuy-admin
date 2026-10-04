import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:noon_admin/firebase_options.dart';

import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import '../models/banner_model.dart';
import '../models/coupon_model.dart';

class FirebaseService extends GetxService {
  final RxBool isFirebaseInitialized = false.obs;
  final RxBool isLiveMode = true.obs;

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
      debugPrint('⚡️ Firebase initialized successfully!');
    } catch (e) {
      debugPrint('⚠️ Firebase setup notice: $e (Falling back to simulated stream engine)');
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
              .toList());
    }
    return const Stream.empty();
  }

  Future<void> addProduct(ProductModel product) async {
    final db = firestore;
    if (db != null) {
      final docRef = db.collection('products').doc();
      final newProduct = product.copyWith();
      await docRef.set(newProduct.toJson()..['id'] = docRef.id);
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    final db = firestore;
    if (db != null) {
      await db.collection('products').doc(product.id).update(product.toJson());
    }
  }

  Future<void> deleteProduct(String productId) async {
    final db = firestore;
    if (db != null) {
      await db.collection('products').doc(productId).delete();
    }
  }

  // ------------ ORDERS (REALTIME CUSTOMER ORDERS) ------------
  Stream<List<OrderModel>> streamOrders() {
    final db = firestore;
    if (db != null) {
      return db
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
              .toList());
    }
    return const Stream.empty();
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final db = firestore;
    if (db != null) {
      await db.collection('orders').doc(orderId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> addOrder(OrderModel order) async {
    final db = firestore;
    if (db != null) {
      final docRef = db.collection('orders').doc();
      await docRef.set(order.toJson()..['id'] = docRef.id);
    }
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
              .toList());
    }
    return const Stream.empty();
  }

  Future<void> addCategory(CategoryModel category) async {
    final db = firestore;
    if (db != null) {
      final docRef = db.collection('categories').doc();
      await docRef.set(category.toJson()..['id'] = docRef.id);
    }
  }

  Future<void> deleteCategory(String id) async {
    final db = firestore;
    if (db != null) {
      await db.collection('categories').doc(id).delete();
    }
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
              .toList());
    }
    return const Stream.empty();
  }

  Future<void> addBanner(BannerModel banner) async {
    final db = firestore;
    if (db != null) {
      final docRef = db.collection('banners').doc();
      await docRef.set(banner.toJson()..['id'] = docRef.id);
    }
  }

  Future<void> deleteBanner(String id) async {
    final db = firestore;
    if (db != null) {
      await db.collection('banners').doc(id).delete();
    }
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
              .toList());
    }
    return const Stream.empty();
  }

  Future<void> toggleUserBlockStatus(String userId, bool isBlocked) async {
    final db = firestore;
    if (db != null) {
      await db.collection('users').doc(userId).update({'isBlocked': isBlocked});
    }
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
              .toList());
    }
    return const Stream.empty();
  }

  Future<void> addCoupon(CouponModel coupon) async {
    final db = firestore;
    if (db != null) {
      final docRef = db.collection('coupons').doc();
      await docRef.set(coupon.toJson()..['id'] = docRef.id);
    }
  }

  Future<void> deleteCoupon(String id) async {
    final db = firestore;
    if (db != null) {
      await db.collection('coupons').doc(id).delete();
    }
  }
}
