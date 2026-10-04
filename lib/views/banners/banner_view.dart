import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/banner_controller.dart';
import '../../models/banner_model.dart';
import '../../config/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BannerView extends StatelessWidget {
  const BannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final BannerController bannerCtrl = Get.find<BannerController>();

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
                    'Promotional Home Banners',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Control the hero slider deals appearing on the Noon mobile application',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddBannerDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add_photo_alternate, size: 20),
                label: const Text(
                  'Add New Banner',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Obx(() {
            final list = bannerCtrl.banners;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 2 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final banner = list[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: banner.imageUrl,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, err) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image, size: 48, color: Colors.grey),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryYellow,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Position #${banner.position}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text(
                                  'Target: ${banner.targetCategory}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => bannerCtrl.deleteBanner(banner.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  void _showAddBannerDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final imageCtrl = TextEditingController(text: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=1200&q=80');
    final BannerController bannerCtrl = Get.find<BannerController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Home Slider Banner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Banner Title', hintText: 'YELLOW FRIDAY SALE - Up to 70% OFF'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: imageCtrl,
              decoration: const InputDecoration(labelText: 'Banner Image URL', hintText: 'https://...'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryYellow, foregroundColor: const Color(0xFF1A1A1A)),
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && imageCtrl.text.isNotEmpty) {
                final banner = BannerModel(
                  id: 'ban_${DateTime.now().millisecondsSinceEpoch}',
                  title: titleCtrl.text.trim(),
                  imageUrl: imageCtrl.text.trim(),
                  createdAt: DateTime.now(),
                );
                bannerCtrl.addBanner(banner);
              }
            },
            child: const Text('Publish Banner'),
          ),
        ],
      ),
    );
  }
}
