import 'package:get/get.dart';
import 'product_controller.dart';
import 'order_controller.dart';
import 'customer_controller.dart';

class DashboardController extends GetxController {
  ProductController get _productCtrl => Get.find<ProductController>();
  OrderController get _orderCtrl => Get.find<OrderController>();
  CustomerController get _customerCtrl => Get.find<CustomerController>();

  double get totalRevenue => _orderCtrl.orders
      .where((o) => o.status != 'Cancelled')
      .fold(0.0, (sum, order) => sum + order.totalAmount);

  int get totalOrders => _orderCtrl.orders.length;

  int get pendingOrders => _orderCtrl.pendingOrdersCount;

  int get totalProducts => _productCtrl.products.length;

  int get expressProducts => _productCtrl.products.where((p) => p.isExpress).length;

  int get lowStockProducts => _productCtrl.products.where((p) => p.stock < 10).length;

  int get totalCustomers => _customerCtrl.customers.length;

  // Weekly Revenue Sales Chart Data
  List<double> get weeklySalesData => [
        4200.0,
        5800.0,
        3900.0,
        7200.0,
        9100.0,
        12400.0,
        totalRevenue > 0 ? totalRevenue : 15800.0,
      ];
}
