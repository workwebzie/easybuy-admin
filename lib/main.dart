import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/app_theme.dart';
import 'services/firebase_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/navigation_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/customer_controller.dart';
import 'controllers/banner_controller.dart';
import 'controllers/coupon_controller.dart';
import 'views/main_layout.dart';
import 'views/auth/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Service
  final firebaseService = FirebaseService();
  await firebaseService.init();
  Get.put<FirebaseService>(firebaseService, permanent: true);

  // Initialize Core GetX Controllers
  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<NavigationController>(NavigationController(), permanent: true);
  Get.put<ProductController>(ProductController(), permanent: true);
  Get.put<OrderController>(OrderController(), permanent: true);
  Get.put<CategoryController>(CategoryController(), permanent: true);
  Get.put<CustomerController>(CustomerController(), permanent: true);
  Get.put<BannerController>(BannerController(), permanent: true);
  Get.put<CouponController>(CouponController(), permanent: true);

  runApp(const NoonAdminApp());
}

class NoonAdminApp extends StatelessWidget {
  const NoonAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authCtrl = Get.find<AuthController>();

    return GetMaterialApp(
      title: 'Noon Admin Dashboard - Full Control Center',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Obx(() {
        return authCtrl.isLoggedIn.value ? const MainLayout() : const LoginView();
      }),
    );
  }
}
