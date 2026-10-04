import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/coupon_controller.dart';
import '../../models/coupon_model.dart';
import '../../config/app_theme.dart';
import 'package:intl/intl.dart';

class CouponView extends StatelessWidget {
  const CouponView({super.key});

  @override
  Widget build(BuildContext context) {
    final CouponController coupCtrl = Get.find<CouponController>();
    final dateFormat = DateFormat('dd MMM yyyy');

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
                    'Coupons & Discount Codes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Create promotional coupons that apply instant discounts during customer checkout',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddCouponDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.confirmation_number_outlined, size: 20),
                label: const Text(
                  'Create New Promo Code',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Obx(() {
            final list = coupCtrl.coupons;
            if (list.isEmpty) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.confirmation_number_outlined, size: 54, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 16),
                        const Text(
                          'No Promo Coupons in Firebase Yet',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Create your first promo code. It will save directly to Firestore collection "coupons".',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => _showAddCouponDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryYellow,
                            foregroundColor: const Color(0xFF1A1A1A),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Create First Promo Code 🎟️', style: TextStyle(fontWeight: FontWeight.bold)),
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
                crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 3 : (MediaQuery.of(context).size.width > 700 ? 2 : 1),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.1,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final coupon = list[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryYellow,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFF1A1A1A)),
                              ),
                              child: Text(
                                coupon.code,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: Color(0xFF1A1A1A),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => coupCtrl.deleteCoupon(coupon.id),
                            ),
                          ],
                        ),
                        Text(
                          coupon.isPercentage
                              ? '${coupon.discountAmount.toInt()}% OFF STOREWIDE'
                              : 'AED ${coupon.discountAmount.toInt()} OFF INSTANT DISCOUNT',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Min Spend: AED ${coupon.minSpend.toInt()}',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                            Text(
                              'Used: ${coupon.usageCount}/${coupon.usageLimit}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3B82F6)),
                            ),
                          ],
                        ),
                        const Divider(height: 12),
                        Text(
                          'Expires on ${dateFormat.format(coupon.expiryDate)}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
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

  void _showAddCouponDialog(BuildContext context) {
    final codeCtrl = TextEditingController();
    final discountCtrl = TextEditingController();
    final minSpendCtrl = TextEditingController(text: '100');
    final CouponController coupCtrl = Get.find<CouponController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Create Discount Promo Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeCtrl,
              decoration: const InputDecoration(labelText: 'Coupon Code', hintText: 'e.g. FLASH15'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: discountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Discount % or Amount in AED', hintText: '15'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: minSpendCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Minimum Spend (AED)', hintText: '100'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryYellow, foregroundColor: const Color(0xFF1A1A1A)),
            onPressed: () {
              if (codeCtrl.text.isNotEmpty && discountCtrl.text.isNotEmpty) {
                final coupon = CouponModel(
                  id: 'coup_${DateTime.now().millisecondsSinceEpoch}',
                  code: codeCtrl.text.trim().toUpperCase(),
                  discountAmount: double.tryParse(discountCtrl.text) ?? 10.0,
                  minSpend: double.tryParse(minSpendCtrl.text) ?? 0.0,
                  expiryDate: DateTime.now().add(const Duration(days: 30)),
                );
                coupCtrl.addCoupon(coupon);
              }
            },
            child: const Text('Publish Promo Code'),
          ),
        ],
      ),
    );
  }
}
