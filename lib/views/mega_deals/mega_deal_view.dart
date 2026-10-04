import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/mega_deal_controller.dart';
import '../../controllers/product_controller.dart';
import '../../models/mega_deal_model.dart';
import '../../config/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class MegaDealView extends StatelessWidget {
  const MegaDealView({super.key});

  @override
  Widget build(BuildContext context) {
    final MegaDealController dealCtrl = Get.find<MegaDealController>();
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Noon Mega Deals ⚡️',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Manage Flash Sales, Deal of the Day, and limited-time offer banners for your mobile app',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddMegaDealDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.flash_on, size: 20),
                label: const Text(
                  'Create Mega Deal ⚡️',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Obx(() {
            final list = dealCtrl.megaDeals;

            if (dealCtrl.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator(color: Color(0xFF1A1A1A))),
              );
            }

            if (list.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.flash_on_outlined, size: 54, color: Color(0xFFD97706)),
                        const SizedBox(height: 16),
                        const Text(
                          'No Active Mega Deals in Firebase Yet',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Create your first flash sale deal. It will display at the top of your mobile app and save to Firestore collection "mega_deals".',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => _showAddMegaDealDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryYellow,
                            foregroundColor: const Color(0xFF1A1A1A),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                          icon: const Icon(Icons.flash_on, size: 18),
                          label: const Text('Create First Mega Deal ⚡️', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : (MediaQuery.of(context).size.width > 768 ? 2 : 1),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.8,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final deal = list[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Badge & Active Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryYellow,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                deal.badgeText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Switch(
                                  value: deal.isActive,
                                  activeColor: const Color(0xFF10B981),
                                  onChanged: (_) => dealCtrl.toggleActive(deal),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () => dealCtrl.deleteMegaDeal(deal.id),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Product Image & Deal Details
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 70,
                                height: 70,
                                color: const Color(0xFFF1F5F9),
                                child: deal.productImage.isNotEmpty
                                    ? CachedNetworkImage(imageUrl: deal.productImage, fit: BoxFit.cover)
                                    : const Icon(Icons.flash_on, color: Colors.amber, size: 32),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    deal.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    deal.productName,
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        'AED ${deal.dealPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (deal.originalPrice > deal.dealPrice)
                                        Text(
                                          'AED ${deal.originalPrice.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            decoration: TextDecoration.lineThrough,
                                            fontSize: 12,
                                            color: Color(0xFF94A3B8),
                                          ),
                                        ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFECFDF5),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '${deal.discountPercent.toInt()}% OFF',
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 12),

                        // Expiry Time Indicator
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 14, color: Color(0xFFD97706)),
                            const SizedBox(width: 6),
                            Text(
                              'Offer Ends: ${dateFormat.format(deal.endTime)}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  void _showAddMegaDealDialog(BuildContext context) {
    final ProductController prodCtrl = Get.find<ProductController>();
    final MegaDealController dealCtrl = Get.find<MegaDealController>();

    final titleCtrl = TextEditingController(text: 'MEGA DEAL OF THE DAY ⚡️');
    final subtitleCtrl = TextEditingController(text: 'Special flash discount - limited stock available!');
    final dealPriceCtrl = TextEditingController();
    final badgeCtrl = TextEditingController(text: 'MEGA DEAL OF THE DAY ⚡️');

    String selectedProductId = prodCtrl.products.isNotEmpty ? prodCtrl.products.first.id : '';
    int durationHours = 24;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          final selectedProduct = prodCtrl.products.firstWhereOrNull((p) => p.id == selectedProductId);

          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.flash_on, color: Color(0xFFD97706)),
                SizedBox(width: 8),
                Text('Create Mega Deal'),
              ],
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: 'Deal Banner Title', hintText: 'MEGA DEAL ⚡️'),
                    ),
                    const SizedBox(height: 12),

                    // Badge Text
                    TextField(
                      controller: badgeCtrl,
                      decoration: const InputDecoration(labelText: 'Badge Tag Text', hintText: 'DEAL OF THE DAY ⚡️'),
                    ),
                    const SizedBox(height: 12),

                    // Product Selector
                    const Text('Select Target Product', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 6),
                    if (prodCtrl.products.isNotEmpty)
                      DropdownButtonFormField<String>(
                        value: selectedProductId.isNotEmpty ? selectedProductId : prodCtrl.products.first.id,
                        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                        items: prodCtrl.products.map((p) {
                          return DropdownMenuItem(
                            value: p.id,
                            child: Text('${p.name} (AED ${p.price.toStringAsFixed(0)})', overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedProductId = val;
                              final prod = prodCtrl.products.firstWhere((p) => p.id == val);
                              dealPriceCtrl.text = (prod.price * 0.7).roundToDouble().toString();
                            });
                          }
                        },
                      )
                    else
                      const Text('No products available. Add products first!', style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 12),

                    // Deal Price
                    TextField(
                      controller: dealPriceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Special Deal Price (AED)',
                        hintText: selectedProduct != null ? 'e.g. ${(selectedProduct.price * 0.7).toStringAsFixed(0)}' : '199',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Timer Duration Dropdown
                    const Text('Deal Duration (Countdown Timer)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      value: durationHours,
                      decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                      items: const [
                        DropdownMenuItem(value: 12, child: Text('12 Hours Flash Deal')),
                        DropdownMenuItem(value: 24, child: Text('24 Hours (1 Day Deal)')),
                        DropdownMenuItem(value: 48, child: Text('48 Hours (2 Days Deal)')),
                        DropdownMenuItem(value: 168, child: Text('7 Days Mega Sale')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => durationHours = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: const Color(0xFF1A1A1A),
                ),
                onPressed: () {
                  final prod = selectedProduct ?? (prodCtrl.products.isNotEmpty ? prodCtrl.products.first : null);
                  final dealPrice = double.tryParse(dealPriceCtrl.text) ?? (prod != null ? prod.price * 0.7 : 199.0);
                  final origPrice = prod?.price ?? dealPrice * 1.3;

                  final deal = MegaDealModel(
                    id: 'deal_${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text.trim(),
                    subtitle: subtitleCtrl.text.trim(),
                    productId: prod?.id ?? 'prod_custom',
                    productName: prod?.name ?? 'Special Mega Product',
                    productImage: (prod != null && prod.images.isNotEmpty) ? prod.images.first : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80',
                    dealPrice: dealPrice,
                    originalPrice: origPrice,
                    discountPercent: origPrice > dealPrice ? (((origPrice - dealPrice) / origPrice) * 100).roundToDouble() : 30.0,
                    endTime: DateTime.now().add(Duration(hours: durationHours)),
                    badgeText: badgeCtrl.text.trim(),
                    createdAt: DateTime.now(),
                  );

                  dealCtrl.addMegaDeal(deal);
                },
                child: const Text('Publish Mega Deal ⚡️', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }
}
