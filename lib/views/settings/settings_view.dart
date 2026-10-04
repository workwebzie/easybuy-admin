import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/firebase_service.dart';
import '../../config/app_theme.dart';
import '../../config/initial_seed_data.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = Get.find<FirebaseService>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Firebase & Store Settings',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                'Configure live Firebase connection, seed Firestore collections, and manage store defaults',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Firebase Connection Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.local_fire_department, color: Color(0xFFD97706), size: 28),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                final isInit = firebaseService.isFirebaseInitialized.value;
                                return Row(
                                  children: [
                                    Text(
                                      isInit ? 'Firebase Connected ⚡️' : 'Demo Stream Mode Active ⚡️',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isInit ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isInit ? 'ONLINE REALTIME' : 'SIMULATED STREAM',
                                        style: TextStyle(
                                          color: isInit ? const Color(0xFF059669) : const Color(0xFF2563EB),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 4),
                              const Text(
                                'Firestore Project: noon-clone-app | Realtime snapshots listening on collections: products, orders, categories, users',
                                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Firestore Seeder Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.cloud_upload_outlined, color: Color(0xFF1A1A1A), size: 32),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Seed / Push Noon Sample Data to Firebase',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Pushes standard Noon product items (iPhone 16 Pro, PS5, Sony WH-1000XM5), categories, banners, and sample orders to your Firestore DB.',
                                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final fs = firebaseService;
                            // Push products
                            for (var p in InitialSeedData.defaultProducts) {
                              await fs.addProduct(p);
                            }
                            // Push categories
                            for (var c in InitialSeedData.defaultCategories) {
                              await fs.addCategory(c);
                            }
                            // Push banners
                            for (var b in InitialSeedData.defaultBanners) {
                              await fs.addBanner(b);
                            }
                            // Push orders
                            for (var o in InitialSeedData.defaultOrders) {
                              await fs.addOrder(o);
                            }
                            Get.snackbar(
                              'Firestore Seeded Successfully! ⚡️',
                              'Products, categories, and sample orders pushed to Firestore',
                              backgroundColor: const Color(0xFF10B981),
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryYellow,
                            foregroundColor: const Color(0xFF1A1A1A),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.flash_on, size: 18),
                          label: const Text(
                            'Seed Data to Firebase 🚀',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Security & Store Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Store Identification & Info',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: null,
                          decoration: InputDecoration(
                            labelText: 'Store Name',
                            hintText: 'Noon Marketplace UAE & KSA',
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: null,
                          decoration: InputDecoration(
                            labelText: 'Currency Code',
                            hintText: 'AED (United Arab Emirates Dirham)',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Fulfillment Strategy',
                            hintText: 'Noon Express ⚡️ 24h & Seller Direct Fulfillment',
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Admin Version',
                            hintText: 'v2.5.0-pro (GetX + Firebase Live)',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
