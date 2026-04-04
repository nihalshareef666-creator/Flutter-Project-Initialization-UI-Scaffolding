import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/product_model.dart';
import 'package:testpro26/providers/product_provider.dart';
import 'package:testpro26/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;
  const CategoryPage({super.key, required this.categoryName});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  void _showDeleteConfirmation(BuildContext context, String barcode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<ProductProvider>(context, listen: false);
              final success = await provider.deleteProduct(barcode);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Product deleted' : 'Failed to delete product')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddEditProductModal(BuildContext context, {Product? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _AddEditProductForm(
            categoryName: widget.categoryName,
            existingProduct: product,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final isAdmin = auth.isAdmin;

    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        final items = provider.products
            .where((p) => p.category.toLowerCase().contains(widget.categoryName.toLowerCase()))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(widget.categoryName),
                if (isAdmin) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'ADMIN MODE',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ],
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
                  ? const Center(
                      child: Text(
                        'No products in this category',
                        style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final product = items[index];
                        return Card(
                          elevation: 2,
                          shadowColor: AppColors.cardShadow,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              context.push('/product/${product.barcode}');
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(
                                              File(product.imageUrl!),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.image_outlined,
                                            size: 30,
                                            color: AppColors.textHint,
                                          ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Brand: ${product.brand}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        Text(
                                          'Barcode: ${product.barcode}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textHint,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isAdmin) ...[
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: AppColors.primary, size: 20),
                                      onPressed: () => _showAddEditProductModal(context, product: product),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                                      onPressed: () => _showDeleteConfirmation(context, product.barcode),
                                    ),
                                  ] else
                                    const Icon(Icons.chevron_right, color: AppColors.textHint),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          floatingActionButton: isAdmin
              ? FloatingActionButton.extended(
                  onPressed: () => _showAddEditProductModal(context),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              : null,
        );
      },
    );
  }
}

class _AddEditProductForm extends StatefulWidget {
  final String categoryName;
  final Product? existingProduct;

  const _AddEditProductForm({required this.categoryName, this.existingProduct});

  @override
  State<_AddEditProductForm> createState() => _AddEditProductFormState();
}

class _AddEditProductFormState extends State<_AddEditProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _barcodeController;
  late TextEditingController _specsController;
  bool _isLoading = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingProduct?.name ?? '');
    _brandController = TextEditingController(text: widget.existingProduct?.brand ?? '');
    _barcodeController = TextEditingController(text: widget.existingProduct?.barcode ?? '');
    if (widget.existingProduct?.imageUrl != null) {
      _imageFile = File(widget.existingProduct!.imageUrl!);
    }
    _specsController = TextEditingController(); 
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    _specsController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final product = Product(
      name: _nameController.text.trim(),
      brand: _brandController.text.trim(),
      category: widget.categoryName, // locked to current category
      barcode: _barcodeController.text.trim(),
      imageUrl: _imageFile?.path,
    );

    final provider = Provider.of<ProductProvider>(context, listen: false);
    bool success;

    if (widget.existingProduct != null) {
      success = await provider.updateProduct(product);
    } else {
      success = await provider.addProduct(product);
    }

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.existingProduct != null ? 'Product updated' : 'Product added')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Operation failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingProduct != null;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Product' : 'Add New Product',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(widget.categoryName, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Brand', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _barcodeController,
              enabled: !isEditing, // Lock barcode editing to preserve integrity
              decoration: const InputDecoration(labelText: 'Barcode Number', border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            const Text('Product Image', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_imageFile!, fit: BoxFit.cover, width: double.infinity),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.primary.withOpacity(0.5)),
                          const SizedBox(height: 8),
                          const Text('Tap to add image', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 12),
            TextFormField(
              controller: _specsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Specifications (Optional)',
                hintText: 'e.g. Wattage: 15W, Warranty: 2 Years',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProduct,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: _isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)) 
                : Text(isEditing ? 'Save Changes' : 'Add Product', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
