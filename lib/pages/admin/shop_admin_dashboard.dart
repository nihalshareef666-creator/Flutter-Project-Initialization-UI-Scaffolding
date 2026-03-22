import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/user_model.dart';

class ShopAdminDashboard extends StatefulWidget {
  final User user;
  const ShopAdminDashboard({super.key, required this.user});

  @override
  State<ShopAdminDashboard> createState() => _ShopAdminDashboardState();
}

class _ShopAdminDashboardState extends State<ShopAdminDashboard> {
  int _selectedMenuIndex = 0;
  final Color adminColor = AppColors.primary; // Blue

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard_outlined},
    {'title': 'Shop Details', 'icon': Icons.storefront_outlined},
    {'title': 'Staff Management', 'icon': Icons.people_outline},
    {'title': 'Brand Management', 'icon': Icons.branding_watermark_outlined},
    {'title': 'Product Overview', 'icon': Icons.inventory_2_outlined},
    {'title': 'Activity Logs', 'icon': Icons.history_outlined},
    {'title': 'Logout', 'icon': Icons.logout, 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Admin Console'),
        backgroundColor: adminColor,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: adminColor),
            accountName: Text(widget.user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.store, color: AppColors.primary, size: 40),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _selectedMenuIndex == index;
                final color = item['color'] ?? (isSelected ? adminColor : AppColors.textSecondary);

                return ListTile(
                  leading: Icon(item['icon'], color: color),
                  title: Text(
                    item['title'],
                    style: TextStyle(
                      color: item['color'] ?? (isSelected ? adminColor : AppColors.textPrimary),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: adminColor.withOpacity(0.05),
                  onTap: () {
                    if (item['title'] == 'Logout') {
                      Navigator.pop(context);
                    } else {
                      setState(() => _selectedMenuIndex = index);
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Enterprise Edition v1.2', style: TextStyle(color: Colors.grey, fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_menuItems[_selectedMenuIndex]['title']) {
      case 'Dashboard':
        return _buildDashboardOverview();
      case 'Shop Details':
        return _buildShopDetails();
      case 'Staff Management':
        return _buildStaffManagement();
      case 'Product Overview':
        return _buildProductOverview();
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_menuItems[_selectedMenuIndex]['icon'], size: 64, color: Colors.grey[200]),
              const SizedBox(height: 16),
              const Text('This section is tailored for your shop data.', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
    }
  }

  Widget _buildDashboardOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Shop Performance', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard('Shop Products', '1,247', Icons.inventory_2_outlined, adminColor),
              const SizedBox(width: 12),
              _buildStatCard('Active Staff', '8', Icons.people_outline, Colors.teal),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Low Stock Items', '14', Icons.warning_amber_rounded, Colors.orange),
              const SizedBox(width: 12),
              _buildStatCard('Monthly Scans', '342', Icons.qr_code_2_rounded, Colors.blue),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Inventory Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildAlertTile('Havells Adonia R 25L is out of stock', 'Immediate attention required', Icons.inventory, Colors.red),
          _buildAlertTile('New staff login detected: Rahul Kumar', '10 minutes ago', Icons.login, Colors.blue),
          _buildAlertTile('V-Guard Water Heater added to catalog', '1 hour ago', Icons.add_circle_outline, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertTile(String msg, String sub, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(sub, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(Icons.store, size: 50, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          const Text('TechPlumb Solutions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text('GSTIN: 27AAAAA0000A1Z5', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          _buildDetailRow('Contact Person', 'Nihal Ahmed'),
          _buildDetailRow('Email', 'owner@techplumb.com'),
          _buildDetailRow('Phone', '+91 98765 43210'),
          _buildDetailRow('Address', '123 Tech Park, Electronics City, Bangalore'),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit, size: 18, color: Colors.white),
              label: const Text('Edit Shop Profile', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: adminColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildStaffManagement() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Staff Members', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () {}, icon: Icon(Icons.add_circle, color: adminColor, size: 28)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.divider)),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: adminColor.withOpacity(0.1), child: const Icon(Icons.person, color: AppColors.primary)),
                  title: const Text('Staff Member Name', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Inventory Manager'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductOverview() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search my shop inventory...',
                    prefixIcon: const Icon(Icons.search),
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_rounded, color: AppColors.primary)),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
                child: Row(
                  children: [
                    Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.image_outlined, color: Colors.grey)),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Premium LED Bulb 12W', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Category: Lighting', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text('In Stock: 42 units', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_outlined, size: 20, color: Colors.grey),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
