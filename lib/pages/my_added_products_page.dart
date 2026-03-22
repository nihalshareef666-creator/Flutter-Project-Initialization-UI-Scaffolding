import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/user_model.dart';
import 'package:testpro26/models/product_model.dart';

class MyAddedProductsPage extends StatefulWidget {
  final User user;
  const MyAddedProductsPage({super.key, required this.user});

  @override
  State<MyAddedProductsPage> createState() => _MyAddedProductsPageState();
}

class _MyAddedProductsPageState extends State<MyAddedProductsPage> {
  late List<Product> allProducts;
  String? selectedShopFilter;
  String? selectedStaffFilter;
  String? selectedBrandFilter;
  String? selectedCategoryFilter;
  
  // For Admin: My Products vs Staff Products
  bool showOnlyMyProducts = false;

  @override
  void initState() {
    super.initState();
    // Dummy Data
    allProducts = [
      Product(
        id: 1,
        name: '1 Pole 16A MCB Schneider',
        brand: 'Schneider',
        category: 'Electrical',
        barcode: '8901234567890',
        addedBy: 'Rahul Sharma',
        addedByRole: UserRole.staff,
        shopName: 'TechPlumb Solutions HQ',
        dateAdded: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Product(
        id: 2,
        name: '25L Water Heater Havells',
        brand: 'Havells',
        category: 'Appliances',
        barcode: '8901234567891',
        addedBy: 'Nihal Owner',
        addedByRole: UserRole.admin,
        shopName: 'TechPlumb Solutions HQ',
        dateAdded: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Product(
        id: 3,
        name: 'Modular Switch 6A Legrand',
        brand: 'Legrand',
        category: 'Electrical',
        barcode: '8901234567892',
        addedBy: 'Rahul Sharma',
        addedByRole: UserRole.staff,
        shopName: 'TechPlumb Solutions HQ',
        dateAdded: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Product(
        id: 4,
        name: 'LED Ceiling Light 18W Philips',
        brand: 'Philips',
        category: 'Lighting',
        barcode: '8901234567893',
        addedBy: 'Tech Support',
        addedByRole: UserRole.administrator,
        shopName: 'System Admin',
        dateAdded: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Product(
        id: 5,
        name: 'Heavy Duty Drill Machine',
        brand: 'Bosch',
        category: 'Tools',
        barcode: '8901234567894',
        addedBy: 'Other Store Staff',
        addedByRole: UserRole.staff,
        shopName: 'Other Electronics Store',
        dateAdded: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  List<Product> get filteredProducts {
    return allProducts.where((p) {
      if (widget.user.role == UserRole.staff) {
        // Staff: only their own products
        return p.addedBy == widget.user.name;
      } else if (widget.user.role == UserRole.admin) {
        // Admin: products in their shop
        bool inShop = p.shopName == widget.user.shopName;
        if (!inShop) return false;
        if (showOnlyMyProducts) {
          return p.addedBy == widget.user.name;
        } else {
          // "Staff Products" filter - products in the shop NOT added by the admin
          return p.addedBy != widget.user.name;
        }
      } else if (widget.user.role == UserRole.administrator) {
        // Administrator: any products, with filters
        if (selectedShopFilter != null && p.shopName != selectedShopFilter) return false;
        if (selectedStaffFilter != null && p.addedBy != selectedStaffFilter) return false;
        if (selectedBrandFilter != null && p.brand != selectedBrandFilter) return false;
        if (selectedCategoryFilter != null && p.category != selectedCategoryFilter) return false;
        return true;
      }
      return false; // Customer shouldn't see this page
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdministrator = widget.user.role == UserRole.administrator;
    final Color themeColor = isAdministrator ? const Color(0xFF673AB7) : AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Added Products'),
        backgroundColor: themeColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilters(themeColor),
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) => _buildProductCard(filteredProducts[index], themeColor),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(Color themeColor) {
    if (widget.user.role == UserRole.staff) return const SizedBox.shrink();

    if (widget.user.role == UserRole.admin) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Text('Filter:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(width: 12),
            ChoiceChip(
              label: const Text('My Products', style: TextStyle(fontSize: 12)),
              selected: showOnlyMyProducts,
              onSelected: (v) => setState(() => showOnlyMyProducts = true),
              selectedColor: themeColor.withOpacity(0.2),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Staff Products', style: TextStyle(fontSize: 12)),
              selected: !showOnlyMyProducts,
              onSelected: (v) => setState(() => showOnlyMyProducts = false),
              selectedColor: themeColor.withOpacity(0.2),
            ),
          ],
        ),
      );
    }

    if (widget.user.role == UserRole.administrator) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Shop', allProducts.map((e) => e.shopName).toSet().toList(), selectedShopFilter, (v) => setState(() => selectedShopFilter = v)),
              const SizedBox(width: 8),
              _buildFilterChip('Staff', allProducts.map((e) => e.addedBy).toSet().toList(), selectedStaffFilter, (v) => setState(() => selectedStaffFilter = v)),
              const SizedBox(width: 8),
              _buildFilterChip('Brand', allProducts.map((e) => e.brand).toSet().toList(), selectedBrandFilter, (v) => setState(() => selectedBrandFilter = v)),
              const SizedBox(width: 8),
              _buildFilterChip('Category', allProducts.map((e) => e.category).toSet().toList(), selectedCategoryFilter, (v) => setState(() => selectedCategoryFilter = v)),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFilterChip(String label, List<String> options, String? selectedValue, Function(String?) onSelected) {
    return PopupMenuButton<String>(
      onSelected: (v) => onSelected(v == 'All' ? null : v),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'All', child: Text('All')),
        ...options.map((e) => PopupMenuItem(value: e, child: Text(e))),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selectedValue != null ? Colors.deepPurple.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selectedValue != null ? Colors.deepPurple : Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Text(selectedValue ?? label, style: TextStyle(fontSize: 12, color: selectedValue != null ? Colors.deepPurple : Colors.black87)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 16, color: selectedValue != null ? Colors.deepPurple : Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.inventory_2_outlined, color: themeColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('${product.brand} • ${product.category}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow(Icons.qr_code, 'Barcode', product.barcode),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.person, 'Added By', '${product.addedBy} (${product.addedByRole.name})'),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.calendar_today, 'Date Added', DateFormat('MMM dd, yyyy').format(product.dateAdded)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (widget.user.role == UserRole.staff)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.visibility, size: 16),
                          label: const Text('View'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: themeColor,
                            side: BorderSide(color: themeColor),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(widget.user.role == UserRole.staff ? Icons.delete : Icons.remove_circle, size: 16),
                        label: Text(widget.user.role == UserRole.staff ? 'Delete' : 'Remove'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textHint),
        const SizedBox(width: 6),
        Text('$label:', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No products found', style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Products added to the system will appear here.', style: TextStyle(color: AppColors.textHint, fontSize: 13)),
        ],
      ),
    );
  }
}
