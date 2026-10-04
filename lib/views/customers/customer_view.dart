import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/customer_controller.dart';
import '../../models/user_model.dart';
import '../../config/app_theme.dart';
import 'package:intl/intl.dart';

class CustomerView extends StatelessWidget {
  const CustomerView({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerController custCtrl = Get.find<CustomerController>();
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
                    'Registered Customers',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Manage registered Noon app users, view total lifetime spend, and toggle account access',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddCustomerDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryYellow,
                  foregroundColor: const Color(0xFF1A1A1A),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.person_add_alt_1, size: 20),
                label: const Text(
                  'Add New Customer',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search Box Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: 320,
                child: TextField(
                  onChanged: (val) => custCtrl.searchQuery.value = val,
                  decoration: const InputDecoration(
                    hintText: 'Search customer name, email, phone...',
                    prefixIcon: Icon(Icons.search, size: 20),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Customer Table Card
          Card(
            child: Obx(() {
              final list = custCtrl.filteredCustomers;
              if (custCtrl.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator(color: Color(0xFF1A1A1A))),
                );
              }

              if (list.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_outline, size: 54, color: Color(0xFF94A3B8)),
                        const SizedBox(height: 16),
                        const Text(
                          'No Registered Customers Yet',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Customers will automatically sync when users register in the mobile app or place orders.',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () => _showAddCustomerDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryYellow,
                            foregroundColor: const Color(0xFF1A1A1A),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          ),
                          icon: const Icon(Icons.person_add, size: 18),
                          label: const Text('Add First Customer Account 👤', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    dataRowMinHeight: 65,
                    dataRowMaxHeight: 70,
                    columns: const [
                      DataColumn(label: Text('CUSTOMER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('PHONE NUMBER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('JOINED DATE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('ORDERS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('LIFETIME SPENT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('ACCOUNT STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                      DataColumn(label: Text('ACTION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    ],
                    rows: list.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFFFEF9C3),
                                  child: Text(
                                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text(user.email, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(user.phone, style: const TextStyle(fontSize: 12))),
                          DataCell(Text(dateFormat.format(user.joinDate), style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
                          DataCell(Text('${user.totalOrders} orders', style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(
                            Text(
                              'AED ${user.totalSpent.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: user.isBlocked ? const Color(0xFFFEE2E2) : const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                user.isBlocked ? 'Blocked' : 'Active Account',
                                style: TextStyle(
                                  color: user.isBlocked ? const Color(0xFFDC2626) : const Color(0xFF059669),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: user.isBlocked ? const Color(0xFF10B981) : Colors.redAccent),
                              ),
                              onPressed: () => custCtrl.toggleBlockStatus(user),
                              child: Text(
                                user.isBlocked ? 'Unblock Account' : 'Block Account',
                                style: TextStyle(
                                  color: user.isBlocked ? const Color(0xFF10B981) : Colors.redAccent,
                                  fontSize: 11,
                                ),
                              ),
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

  void _showAddCustomerDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController(text: '+971 50 ');
    final CustomerController custCtrl = Get.find<CustomerController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Add Customer Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Customer Full Name', hintText: 'Mohammed Al-Hashmi'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email Address', hintText: 'm.alhashmi@gmail.com'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number', hintText: '+971 50 123 4567'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryYellow, foregroundColor: const Color(0xFF1A1A1A)),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && emailCtrl.text.isNotEmpty) {
                final user = UserModel(
                  id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  joinDate: DateTime.now(),
                );
                custCtrl.addCustomer(user);
              }
            },
            child: const Text('Register Customer Account'),
          ),
        ],
      ),
    );
  }
}
