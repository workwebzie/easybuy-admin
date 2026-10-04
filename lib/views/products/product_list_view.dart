import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../config/app_theme.dart';
import 'product_form_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController prodCtrl = Get.find<ProductController>();

    final List<String> categories = [
      'All',
      'Electronics',
      'Fashion',
      'Home',
      'Beauty',
      'Supermarket',
      'Toys & Games',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Noon Store Products',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Manage items, pricing, inventory stock, and Noon Express ⚡️ status',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Get.dialog(const ProductFormDialog());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: const Text(
                  'Add New Product ⚡️',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filters & Search Bar Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  // Search Box
                  SizedBox(
                    width: 300,
                    child: TextField(
                      onChanged: (val) => prodCtrl.searchQuery.value = val,
                      decoration: const InputDecoration(
                        hintText: 'Search product title, brand...',
                        prefixIcon: Icon(Icons.search, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),

                  // Category Dropdown Filter
                  Obx(() {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: prodCtrl.selectedCategory.value,
                          items: categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text('Category: $cat', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) prodCtrl.selectedCategory.value = val;
                          },
                        ),
                      ),
                    );
                  }),

                  // Filter Chips (Express & Low Stock)
                  Obx(() {
                    return FilterChip(
                      selected: prodCtrl.onlyExpress.value,
                      label: const Text('Noon Express ⚡️ Only'),
                      selectedColor: AppTheme.primaryYellow,
                      onSelected: (val) => prodCtrl.onlyExpress.value = val,
                    );
                  }),

                  Obx(() {
                    return FilterChip(
                      selected: prodCtrl.onlyLowStock.value,
                      label: const Text('Low Stock (< 10) ⚠️'),
                      selectedColor: const Color(0xFFFEE2E2),
                      onSelected: (val) => prodCtrl.onlyLowStock.value = val,
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Products Data Table
          Card(
            child: Obx(() {
              final list = prodCtrl.filteredProducts;
              if (prodCtrl.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator(color: Color(0xFF1A1A1A))),
                );
              }

              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 48, color: Color(0xFF94A3B8)),
                        SizedBox(height: 12),
                        Text(
                          'No products matching your search criteria',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 320),
                  child: DataTable(
                    headingRowHeight: 50,
                    dataRowMinHeight: 70,
                    dataRowMaxHeight: 80,
                    columns: const [
                      DataColumn(label: Text('PRODUCT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('CATEGORY / BRAND', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('PRICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('STOCK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('EXPRESS ⚡️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                    rows: list.map((product) {
                      return DataRow(
                        cells: [
                          // Thumbnail & Title
                          DataCell(
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    color: const Color(0xFFF1F5F9),
                                    child: product.images.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: product.images.first,
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) => const Icon(Icons.image, color: Colors.grey),
                                          )
                                        : const Icon(Icons.image, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 220,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, size: 13, color: Color(0xFFF59E0B)),
                                          Text(
                                            ' ${product.rating} (${product.reviewCount})',
                                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Category & Brand
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(product.category, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                Text(product.brand, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              ],
                            ),
                          ),

                          // Price & Discount
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'AED ${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                                ),
                                if (product.originalPrice > product.price)
                                  Row(
                                    children: [
                                      Text(
                                        'AED ${product.originalPrice.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          fontSize: 11,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${product.discountPercent.toInt()}% OFF',
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),

                          // Stock Count Badge
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: product.stock < 10 ? const Color(0xFFFEE2E2) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${product.stock} left',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: product.stock < 10 ? const Color(0xFFDC2626) : const Color(0xFF334155),
                                ),
                              ),
                            ),
                          ),

                          // Express ⚡️ Toggle
                          DataCell(
                            Tooltip(
                              message: product.isExpress ? 'Noon Express Active' : 'Standard Delivery',
                              child: Switch(
                                value: product.isExpress,
                                activeColor: const Color(0xFF1A1A1A),
                                activeTrackColor: AppTheme.primaryYellow,
                                onChanged: (_) => prodCtrl.toggleExpress(product),
                              ),
                            ),
                          ),

                          // Active Status Toggle
                          DataCell(
                            Switch(
                              value: product.isActive,
                              activeColor: const Color(0xFF10B981),
                              onChanged: (_) => prodCtrl.toggleActive(product),
                            ),
                          ),

                          // Action Menu
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_note, color: Color(0xFF2563EB)),
                                  tooltip: 'Edit Product',
                                  onPressed: () {
                                    Get.dialog(ProductFormDialog(product: product));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626)),
                                  tooltip: 'Delete Product',
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        title: const Text('Delete Product?'),
                                        content: Text('Are you sure you want to remove "${product.name}" from store catalog?'),
                                        actions: [
                                          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                                            onPressed: () {
                                              Get.back();
                                              prodCtrl.deleteProduct(product.id);
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
