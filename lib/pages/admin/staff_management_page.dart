import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/user_model.dart';

class StaffManagementPage extends StatefulWidget {
  final User user;
  const StaffManagementPage({super.key, required this.user});

  @override
  State<StaffManagementPage> createState() => _StaffManagementPageState();
}

class _StaffManagementPageState extends State<StaffManagementPage> {
  late List<User> allStaff;
  String? selectedShopFilter;

  @override
  void initState() {
    super.initState();
    // Dummy Data
    allStaff = [
      User(
        name: 'Rahul Sharma',
        email: 'rahul@techplumb.com',
        phone: '+91 8887776660',
        shopName: 'TechPlumb Solutions HQ',
        shopId: 'SHOP_001',
        role: UserRole.staff,
      ),
      User(
        name: 'Anita Desai',
        email: 'anita@techplumb.com',
        phone: '+91 7776665551',
        shopName: 'TechPlumb Solutions HQ',
        shopId: 'SHOP_001',
        role: UserRole.staff,
      ),
      User(
        name: 'Kevin Smith',
        email: 'kevin@globalstore.com',
        phone: '+1 444-555-666',
        shopName: 'Global Electricals',
        shopId: 'SHOP_002',
        role: UserRole.staff,
      ),
      User(
        name: 'Sarah Connor',
        email: 'sarah@globalstore.com',
        phone: '+1 222-333-444',
        shopName: 'Global Electricals',
        shopId: 'SHOP_002',
        role: UserRole.staff,
      ),
    ];
  }

  List<User> get filteredStaff {
    if (widget.user.role == UserRole.admin) {
      // Admin: Only staff from THEIR shop
      return allStaff.where((s) => s.shopId == widget.user.shopId).toList();
    } else if (widget.user.role == UserRole.administrator) {
      // Administrator: All staff, optional shop filter
      if (selectedShopFilter != null) {
        return allStaff.where((s) => s.shopName == selectedShopFilter).toList();
      }
      return allStaff;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdministrator = widget.user.role == UserRole.administrator;
    final Color themeColor = isAdministrator ? const Color(0xFF673AB7) : AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Staff Management'),
        backgroundColor: themeColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(themeColor),
          if (isAdministrator) _buildShopFilter(themeColor),
          Expanded(
            child: filteredStaff.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredStaff.length,
                    itemBuilder: (context, index) => _buildStaffCard(filteredStaff[index], themeColor),
                  ),
          ),
        ],
      ),
      floatingActionButton: widget.user.role == UserRole.admin || isAdministrator
          ? FloatingActionButton.extended(
              onPressed: () => _showAddStaffDialog(themeColor),
              backgroundColor: themeColor,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('Add Staff', style: TextStyle(color: Colors.white)),
            )
          : null,
    );
  }

  Widget _buildHeader(Color themeColor) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.user.role == UserRole.admin ? 'Managing: ${widget.user.shopName}' : 'Enterprise Staff Control',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            '${filteredStaff.length} Active Staff Members',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: themeColor),
          ),
        ],
      ),
    );
  }

  Widget _buildShopFilter(Color themeColor) {
    List<String> shops = allStaff.map((e) => e.shopName!).toSet().toList();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Text('Filter Shop:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('All Shops', style: TextStyle(fontSize: 12)),
              selected: selectedShopFilter == null,
              onSelected: (v) => setState(() => selectedShopFilter = null),
              selectedColor: themeColor.withOpacity(0.2),
            ),
            ...shops.map((s) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ChoiceChip(
                    label: Text(s, style: const TextStyle(fontSize: 12)),
                    selected: selectedShopFilter == s,
                    onSelected: (v) => setState(() => selectedShopFilter = v ? s : null),
                    selectedColor: themeColor.withOpacity(0.2),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffCard(User staff, Color themeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: themeColor.withOpacity(0.1),
          child: Text(staff.name[0], style: TextStyle(color: themeColor, fontWeight: FontWeight.bold)),
        ),
        title: Text(staff.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(staff.email, style: const TextStyle(fontSize: 12)),
            if (widget.user.role == UserRole.administrator)
              Text('Shop: ${staff.shopName}', style: const TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Edit')])),
            const PopupMenuItem(value: 'remove', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text('Remove', style: TextStyle(color: Colors.red))])),
          ],
          onSelected: (v) => _snack('Staff updated: ${staff.name}'),
        ),
      ),
    );
  }

  void _showAddStaffDialog(Color themeColor) {
    // This dialog simulates creating a staff member
    // Rule 2: Staff automatically inherits the admin's shop_id
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Staff'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Full Name')),
            const TextField(decoration: InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            if (widget.user.role == UserRole.admin)
              Text('Inherited Shop: ${widget.user.shopName}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _snack('Staff member added successfully to ${widget.user.shopName ?? "Selected Shop"}');
            },
            style: ElevatedButton.styleFrom(backgroundColor: themeColor),
            child: const Text('Add Member', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('No staff members found in this shop.'));
  }
}
