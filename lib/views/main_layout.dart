import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/order_controller.dart';
import '../services/firebase_service.dart';
import '../config/app_theme.dart';
import 'dashboard/dashboard_view.dart';
import 'products/product_list_view.dart';
import 'orders/order_list_view.dart';
import 'categories/category_view.dart';
import 'banners/banner_view.dart';
import 'mega_deals/mega_deal_view.dart';
import 'customers/customer_view.dart';
import 'coupons/coupon_view.dart';
import 'orders/order_detail_dialog.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navCtrl = Get.find<NavigationController>();
    final AuthController authCtrl = Get.find<AuthController>();
    final OrderController orderCtrl = Get.find<OrderController>();
    final FirebaseService firebaseService = Get.find<FirebaseService>();

    return Scaffold(
      backgroundColor: AppTheme.bodyBg,
      body: Row(
        children: [
          // Sidebar Navigation Drawer (Dark Theme Slate #0F172A)
          Container(
            width: 250,
            color: const Color(0xFF0F172A),
            child: Column(
              children: [
                // Top Brand Logo Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryYellow,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'EasyBuy',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'ADMIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Navigation Links List
                Expanded(
                  child: Obx(() {
                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _buildNavItem(
                          icon: Icons.dashboard_outlined,
                          activeIcon: Icons.dashboard,
                          label: 'Dashboard',
                          tab: AdminTab.dashboard,
                          currentTab: navCtrl.activeTab.value,
                          onTap: () => navCtrl.changeTab(AdminTab.dashboard),
                        ),
                        _buildNavItem(
                          icon: Icons.local_mall_outlined,
                          activeIcon: Icons.local_mall,
                          label: 'Orders',
                          tab: AdminTab.orders,
                          currentTab: navCtrl.activeTab.value,
                          badgeCount: orderCtrl.pendingOrdersCount,
                          onTap: () => navCtrl.changeTab(AdminTab.orders),
                        ),
                        _buildNavItem(
                          icon: Icons.inventory_2_outlined,
                          activeIcon: Icons.inventory_2,
                          label: 'Products',
                          tab: AdminTab.products,
                          currentTab: navCtrl.activeTab.value,
                          onTap: () => navCtrl.changeTab(AdminTab.products),
                        ),
                        _buildNavItem(
                          icon: Icons.category_outlined,
                          activeIcon: Icons.category,
                          label: 'Categories',
                          tab: AdminTab.categories,
                          currentTab: navCtrl.activeTab.value,
                          onTap: () => navCtrl.changeTab(AdminTab.categories),
                        ),
                        _buildNavItem(
                          icon: Icons.view_carousel_outlined,
                          activeIcon: Icons.view_carousel,
                          label: 'Home Banners',
                          tab: AdminTab.banners,
                          currentTab: navCtrl.activeTab.value,
                          onTap: () => navCtrl.changeTab(AdminTab.banners),
                        ),
                        _buildNavItem(
                          icon: Icons.flash_on_outlined,
                          activeIcon: Icons.flash_on,
                          label: 'Mega Deals ⚡️',
                          tab: AdminTab.megaDeals,
                          currentTab: navCtrl.activeTab.value,
                          onTap: () => navCtrl.changeTab(AdminTab.megaDeals),
                        ),
                        _buildNavItem(
                          icon: Icons.people_outline,
                          activeIcon: Icons.people,
                          label: 'Customers',
                          tab: AdminTab.customers,
                          currentTab: navCtrl.activeTab.value,
                          onTap: () => navCtrl.changeTab(AdminTab.customers),
                        ),
                        _buildNavItem(
                          icon: Icons.confirmation_number_outlined,
                          activeIcon: Icons.confirmation_number,
                          label: 'Coupons',
                          tab: AdminTab.coupons,
                          currentTab: navCtrl.activeTab.value,
                          onTap: () => navCtrl.changeTab(AdminTab.coupons),
                        ),
                      ],
                    );
                  }),
                ),

                // Firebase Status Indicator Card on Sidebar
                Obx(() {
                  final isInit = firebaseService.isFirebaseInitialized.value;
                  return Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isInit ? const Color(0xFF10B981) : Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isInit ? 'Firestore Live ⚡️' : 'Demo Mode Active',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Real-time sync active',
                                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),

          // Main View Content Shell
          Expanded(
            child: Column(
              children: [
                // Top Action Bar
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Active Tab Title
                      Obx(() {
                        return Text(
                          _getTabTitle(navCtrl.activeTab.value),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        );
                      }),

                      // Right Header Utilities
                      Row(
                        children: [
                          // Quick Order Simulation Button
                          ElevatedButton.icon(
                            onPressed: () => orderCtrl.simulateCustomerOrder(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryYellow,
                              foregroundColor: const Color(0xFF1A1A1A),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.flash_on, size: 18),
                            label: const Text(
                              'Test Order 🛒',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Real-time Pending Order Bell Notification Badge
                          Obx(() {
                            final pendingCount = orderCtrl.pendingOrdersCount;
                            final latest = orderCtrl.latestNewOrder.value;

                            return PopupMenuButton(
                              icon: Stack(
                                children: [
                                  const Icon(Icons.notifications_none_outlined, size: 26, color: Color(0xFF334155)),
                                  if (pendingCount > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '$pendingCount',
                                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  enabled: false,
                                  child: Text(
                                    '$pendingCount Pending Customer Orders',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                  ),
                                ),
                                if (latest != null)
                                  PopupMenuItem(
                                    onTap: () => Get.dialog(OrderDetailDialog(order: latest)),
                                    child: ListTile(
                                      leading: const Icon(Icons.shopping_bag, color: Color(0xFF1A1A1A)),
                                      title: Text('New Order ${latest.orderNumber}'),
                                      subtitle: Text('${latest.customerName} • AED ${latest.totalAmount.toStringAsFixed(2)}'),
                                    ),
                                  )
                                else
                                  const PopupMenuItem(
                                    enabled: false,
                                    child: Text('No unread notifications'),
                                  ),
                              ],
                            );
                          }),
                          const SizedBox(width: 16),

                          // Admin Profile Menu
                          Obx(() {
                            return PopupMenuButton<String>(
                              onSelected: (val) {
                                if (val == 'logout') authCtrl.logout();
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppTheme.primaryYellow,
                                    radius: 18,
                                    child: const Text(
                                      'N',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        authCtrl.adminName.value,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                                      ),
                                      Text(
                                        authCtrl.adminRole.value,
                                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B)),
                                ],
                              ),
                              itemBuilder: (ctx) => [
                                const PopupMenuItem(value: 'logout', child: Text('Sign Out')),
                              ],
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main Tab Page Renderer
                Expanded(
                  child: Obx(() {
                    switch (navCtrl.activeTab.value) {
                      case AdminTab.dashboard:
                        return const DashboardView();
                      case AdminTab.products:
                        return const ProductListView();
                      case AdminTab.orders:
                        return const OrderListView();
                      case AdminTab.categories:
                        return const CategoryView();
                      case AdminTab.banners:
                        return const BannerView();
                      case AdminTab.megaDeals:
                        return const MegaDealView();
                      case AdminTab.customers:
                        return const CustomerView();
                      case AdminTab.coupons:
                        return const CouponView();
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required AdminTab tab,
    required AdminTab currentTab,
    required VoidCallback onTap,
    int badgeCount = 0,
  }) {
    final isSelected = currentTab == tab;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          hoverColor: const Color(0xFF1E293B),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isSelected ? Border.all(color: AppTheme.primaryYellow.withOpacity(0.5)) : null,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? AppTheme.primaryYellow : const Color(0xFF94A3B8),
                  size: 20,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (badgeCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTabTitle(AdminTab tab) {
    switch (tab) {
      case AdminTab.dashboard:
        return 'Dashboard Overview 📊';
      case AdminTab.products:
        return 'Products & Inventory 📦';
      case AdminTab.orders:
        return 'Customer Orders 🛍️';
      case AdminTab.categories:
        return 'Categories & Departments 🏷️';
      case AdminTab.banners:
        return 'Promotional Banners 🖼️';
      case AdminTab.megaDeals:
        return 'Noon Mega Deals ⚡️';
      case AdminTab.customers:
        return 'Customer Accounts 👥';
      case AdminTab.coupons:
        return 'Coupons & Promo Codes 🎟️';
    }
  }
}
