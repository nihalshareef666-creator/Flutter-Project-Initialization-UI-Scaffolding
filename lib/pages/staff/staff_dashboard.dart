import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/user_model.dart';
import 'package:testpro26/pages/barcode_scanner_page.dart';
import 'package:go_router/go_router.dart';

class StaffDashboard extends StatefulWidget {
  final User user;
  const StaffDashboard({super.key, required this.user});

  @override
  State<StaffDashboard> createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  int _selectedTab = 0; // 0: Inventory List, 1: Add Product
  final Color staffColor = Colors.green[700]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Product Management'),
        backgroundColor: staffColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BarcodeScannerPage(standalone: true)),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
      floatingActionButton: _selectedTab == 0
          ? FloatingActionButton(
              onPressed: () => setState(() => _selectedTab = 1),
              backgroundColor: staffColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: staffColor),
            accountName: Text(widget.user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.inventory_2, color: Colors.green, size: 40),
            ),
          ),
          _buildDrawerTile('Product Catalog', Icons.inventory_2_outlined, 0),
          _buildDrawerTile('Register New Product', Icons.add_box_outlined, 1),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(String title, IconData icon, int index) {
    final isSelected = _selectedTab == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? staffColor : AppColors.textSecondary),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? staffColor : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: staffColor.withOpacity(0.05),
      onTap: () {
        setState(() => _selectedTab = index);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBody() {
    return _selectedTab == 0 ? _buildProductList() : _buildAddProductForm();
  }

  Widget _buildProductList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search inventory...',
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.grey[50],
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 8,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.divider),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.electrical_services_outlined, color: staffColor),
                  ),
                  title: const Text('Product Name SKU-XXXX', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Category: Electrical | Stock: 10 units'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/product-details/890123456789');
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddProductForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle_outline, color: staffColor),
              const SizedBox(width: 10),
              const Text('Add New Inventory Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          _smallLabel('Product Name'),
          _textField('e.g. Philips LED Bulb 12W'),
          const SizedBox(height: 16),
          _smallLabel('Brand'),
          _textField('e.g. Philips'),
          const SizedBox(height: 16),
          _smallLabel('Category'),
          _textField('e.g. Lighting'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _smallLabel('Stock Quantity'),
                    _textField('0'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _smallLabel('Unit Price'),
                    _textField('0.00'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _selectedTab = 0);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Product Registered Successfully'),
                    backgroundColor: staffColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: staffColor),
              child: const Text('REGISTER PRODUCT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => setState(() => _selectedTab = 0),
              child: const Text('Cancel Request', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary)),
    );
  }

  Widget _textField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
