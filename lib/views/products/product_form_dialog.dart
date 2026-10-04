import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product_model.dart';
import '../../controllers/product_controller.dart';
import '../../services/storage_service.dart';
import '../../config/app_theme.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductModel? product;

  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _origPriceController;
  late TextEditingController _stockController;
  late TextEditingController _brandController;
  late TextEditingController _imageUrlController;

  String _selectedCategory = 'Electronics';
  bool _isExpress = true;
  bool _isFeatured = true;
  bool _isActive = true;
  bool _isUploadingImage = false;

  final List<String> _categories = [
    'Electronics',
    'Fashion',
    'Home',
    'Beauty',
    'Supermarket',
    'Toys & Games',
    'Baby & Kids',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _priceController = TextEditingController(text: p != null ? p.price.toString() : '');
    _origPriceController = TextEditingController(text: p != null ? p.originalPrice.toString() : '');
    _stockController = TextEditingController(text: p != null ? p.stock.toString() : '25');
    _brandController = TextEditingController(text: p?.brand ?? '');
    _imageUrlController = TextEditingController(
      text: (p != null && p.images.isNotEmpty)
          ? p.images.first
          : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80',
    );
    if (p != null && _categories.contains(p.category)) {
      _selectedCategory = p.category;
    }
    _isExpress = p?.isExpress ?? true;
    _isFeatured = p?.isFeatured ?? false;
    _isActive = p?.isActive ?? true;
  }

  Future<void> _pickImage() async {
    setState(() => _isUploadingImage = true);
    String? url = await StorageService.pickAndUploadImage(folder: 'products');
    if (url != null) {
      _imageUrlController.text = url;
    }
    setState(() => _isUploadingImage = false);
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final ProductController prodCtrl = Get.find<ProductController>();
      final price = double.parse(_priceController.text);
      final origPrice = _origPriceController.text.isNotEmpty
          ? double.parse(_origPriceController.text)
          : price;
      
      final imageUrl = _imageUrlController.text.isNotEmpty
          ? _imageUrlController.text
          : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80';

      final productModel = ProductModel(
        id: widget.product?.id ?? 'prod_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        originalPrice: origPrice,
        category: _selectedCategory,
        brand: _brandController.text.trim().isEmpty ? 'Generic' : _brandController.text.trim(),
        stock: int.parse(_stockController.text),
        isExpress: _isExpress,
        isFeatured: _isFeatured,
        isActive: _isActive,
        images: [imageUrl],
        createdAt: widget.product?.createdAt ?? DateTime.now(),
      );

      if (widget.product == null) {
        prodCtrl.addProduct(productModel);
      } else {
        prodCtrl.updateProduct(productModel);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryYellow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.inventory, color: Color(0xFF1A1A1A)),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isEditing ? 'Edit Noon Product' : 'Add New Noon Product',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const Divider(height: 24),
                
                // Name
                const Text('Product Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'e.g. Apple iPhone 16 Pro Max 256GB'),
                  validator: (v) => v == null || v.isEmpty ? 'Please enter product title' : null,
                ),
                const SizedBox(height: 16),

                // Category & Brand Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) => setState(() => _selectedCategory = val!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Brand', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _brandController,
                            decoration: const InputDecoration(hintText: 'e.g. Apple, Sony, Nike'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Pricing Row (Price, Original Price, Stock)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Price (AED)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: '299.00'),
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Original Price (AED)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _origPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: '399.00 (For discount badge)'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Stock Quantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _stockController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(hintText: '50'),
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Image Upload / URL
                const Text('Product Image', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          hintText: 'https://images.unsplash.com/... or upload',
                          prefixIcon: Icon(Icons.image_outlined, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _isUploadingImage ? null : _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      icon: _isUploadingImage
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.upload_file, size: 18),
                      label: const Text('Upload Image'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Detailed product specifications and features...'),
                ),
                const SizedBox(height: 16),

                // Toggles Row (Noon Express ⚡️, Featured, Active)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Switch(
                            value: _isExpress,
                            activeColor: const Color(0xFF1A1A1A),
                            activeTrackColor: AppTheme.primaryYellow,
                            onChanged: (val) => setState(() => _isExpress = val),
                          ),
                          const SizedBox(width: 4),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Noon Express ⚡️', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text('Fast 24-hour fulfillment', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Switch(
                            value: _isFeatured,
                            onChanged: (val) => setState(() => _isFeatured = val),
                          ),
                          const Text('Featured', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          Switch(
                            value: _isActive,
                            onChanged: (val) => setState(() => _isActive = val),
                          ),
                          const Text('Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryYellow,
                        foregroundColor: const Color(0xFF1A1A1A),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        isEditing ? 'Save Changes' : 'Create Product ⚡️',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
