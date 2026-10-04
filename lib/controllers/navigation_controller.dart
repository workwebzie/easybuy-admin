import 'package:get/get.dart';

enum AdminTab {
  dashboard,
  products,
  orders,
  categories,
  banners,
  customers,
  coupons,
  settings,
}

class NavigationController extends GetxController {
  final Rx<AdminTab> activeTab = AdminTab.dashboard.obs;

  void changeTab(AdminTab tab) {
    activeTab.value = tab;
  }
}
