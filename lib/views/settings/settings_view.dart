import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon_admin/firebase_options.dart';
import '../../services/firebase_service.dart';
import '../../config/app_theme.dart';
import '../../config/initial_seed_data.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = Get.find<FirebaseService>();
    final currentProjectId = DefaultFirebaseOptions.currentPlatform.projectId;

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
                                      isInit ? 'Firebase Project: $currentProjectId ⚡️' : 'Firebase Offline ⚡️',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isInit ? const Color(0xFFECFDF5) : const Color(0xFFFEE2E2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isInit ? 'CONNECTED REALTIME' : 'CONNECTION ERROR',
                                        style: TextStyle(
                                          color: isInit ? const Color(0xFF059669) : const Color(0xFFDC2626),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              const SizedBox(height: 4),
                              Text(
                                'App is listening on Firestore collections: products, orders, categories, banners, users, coupons',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 32),

                  // Firestore Security Rules Warning Box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.shield_outlined, color: Color(0xFFD97706), size: 22),
                            SizedBox(width: 10),
                            Text(
                              '⚠️ Important: Enable Firestore Read/Write Rules in Firebase Console',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF92400E)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'If your newly created Firebase items fail to reflect in Firebase, your Firestore Security Rules may be blocking unauthenticated writes. Make sure your rules in Firebase Console allow read & write:',
                          style: TextStyle(fontSize: 12, color: Color(0xFF78350F)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const SelectableText(
                            "rules_version = '2';\nservice cloud.firestore {\n  match /databases/{database}/documents {\n    match /{document=**} {\n      allow read, write: if true;\n    }\n  }\n}",
                            style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFFFEEE00)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

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
                                'Push Standard Noon Catalog to Firebase',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Populate your Firestore DB with standard Noon products, categories, banners, and test orders.',
                                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final fs = firebaseService;
                            bool success = true;
                            // Push products
                            for (var p in InitialSeedData.defaultProducts) {
                              bool res = await fs.addProduct(p);
                              if (!res) success = false;
                            }
                            // Push categories
                            for (var c in InitialSeedData.defaultCategories) {
                              bool res = await fs.addCategory(c);
                              if (!res) success = false;
                            }
                            // Push banners
                            for (var b in InitialSeedData.defaultBanners) {
                              bool res = await fs.addBanner(b);
                              if (!res) success = false;
                            }
                            // Push orders
                            for (var o in InitialSeedData.defaultOrders) {
                              bool res = await fs.addOrder(o);
                              if (!res) success = false;
                            }
                            if (success) {
                              Get.snackbar(
                                'Firestore Seeded Successfully! ⚡️',
                                'Products, categories, and sample orders saved to project $currentProjectId',
                                backgroundColor: const Color(0xFF10B981),
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryYellow,
                            foregroundColor: const Color(0xFF1A1A1A),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.flash_on, size: 18),
                          label: const Text(
                            'Push Sample Data to Firebase 🚀',
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
                    'Store Identification & Firebase Options',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(text: currentProjectId),
                          decoration: const InputDecoration(
                            labelText: 'Active Firebase Project ID',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Currency Code',
                            hintText: 'AED (United Arab Emirates Dirham)',
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
