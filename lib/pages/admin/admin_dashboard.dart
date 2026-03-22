import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';

class AdminDashboard extends StatefulWidget {
  final String role;
  const AdminDashboard({super.key, this.role = 'Administrator'});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedMenuIndex = 0;
  bool _isAddingProduct = false;
  bool _isAddingStaff = false;
  String? _viewingActivityFor;
  String _selectedCategory = 'Electrical';
  List<String> _brands = ['Havells', 'Philips', 'Schneider', 'V-Guard', 'Legrand', 'Jaquar', 'Finolex', 'Anchor', 'Bajaj'];
  late String _selectedBrand;
  
  // Form State
  final List<Map<String, String>> _tempSpecs = [{'label': 'Capacity', 'value': ''}, {'label': 'Power', 'value': ''}];
  final List<String> _tempFeatures = [''];

  @override
  void initState() {
    super.initState();
    _selectedBrand = _brands.first;
  }

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard', 'icon': Icons.dashboard_outlined, 'group': 'Admin'},
    {'title': 'Product Management', 'icon': Icons.inventory_2_outlined, 'group': 'Admin'},
    {'title': 'Brand Management', 'icon': Icons.branding_watermark_outlined, 'group': 'Admin'},
    {'title': 'Shop Details', 'icon': Icons.store_outlined, 'group': 'Admin'},
    {'title': 'Shop Management', 'icon': Icons.business_outlined, 'group': 'Administrator'},
    {'title': 'Staff Management', 'icon': Icons.people_outline, 'group': 'Administrator'},
    {'title': 'Verification Status', 'icon': Icons.verified_user_outlined, 'group': 'Administrator'},
    {'title': 'Activity Logs', 'icon': Icons.list_alt_outlined, 'group': 'Administrator'},
    {'title': 'Settings', 'icon': Icons.settings_outlined, 'group': 'Administrator'},
    {'title': 'Logout', 'icon': Icons.logout, 'color': Colors.red, 'group': 'System'},
  ];

  Color _getGroupColor(Map<String, dynamic> item, bool isSelected) {
    if (item['title'] == 'Logout') return Colors.red;
    if (item['group'] == 'Administrator') return Colors.deepPurple;
    if (item['group'] == 'Admin') return AppColors.primary;
    return AppColors.textSecondary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAddingProduct ? 'Add New Product' : 'Admin Panel'),
        leading: (_isAddingProduct || _isAddingStaff || _viewingActivityFor != null)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isAddingProduct = false;
                    _isAddingStaff = false;
                    _viewingActivityFor = null;
                  });
                },
              )
            : null,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              accountName: const Text('Shop Owner', style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: const Text('owner@techplumb.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primary, size: 40),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final item = _menuItems[index];

                  // Filter items based on role
                  if (widget.role == 'Admin' && item['group'] == 'Administrator') {
                    return const SizedBox.shrink();
                  }
                  
                  final isSelected = _selectedMenuIndex == index;
                  final groupColor = _getGroupColor(item, isSelected);
                  
                  // Show headers for the groups
                  Widget? header;
                  if (index == 0) {
                    header = _buildDrawerHeader('ADMIN OPTIONS', AppColors.primary);
                  } else if (index == 4 && widget.role == 'Administrator') { // Only show admin headers if in Admin role
                    header = _buildDrawerHeader('ADMINISTRATOR OPTIONS', Colors.deepPurple);
                  }

                  if (widget.role == 'Admin' && index == 0) {
                    header = _buildDrawerHeader('SHOP ADMIN OPTIONS', AppColors.primary);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (header != null) header,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: ListTile(
                          leading: Icon(
                            item['icon'],
                            color: groupColor, // Always show group color
                          ),
                          title: Text(
                            item['title'],
                            style: TextStyle(
                              color: item['title'] == 'Logout' ? Colors.red : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: groupColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          onTap: () {
                            if (item['title'] == 'Logout') {
                              Navigator.pop(context); // Close drawer
                              Navigator.pop(context); // Exit admin panel
                            } else {
                              setState(() {
                                _selectedMenuIndex = index;
                                _isAddingProduct = false;
                                _isAddingStaff = false;
                                _viewingActivityFor = null;
                              });
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: _buildBody(),
      floatingActionButton: (!_isAddingProduct && !_isAddingStaff && _viewingActivityFor == null)
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _isAddingProduct = true),
              icon: const Icon(Icons.add),
              label: const Text('Add New Product'),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isAddingProduct) return _buildProductUploadForm();
    if (_isAddingStaff) return _buildStaffForm();
    if (_viewingActivityFor != null) return _buildStaffActivityView();

    switch (_menuItems[_selectedMenuIndex]['title']) {
      case 'Dashboard':
        return _buildDashboard();
      case 'Brand Management':
        return _buildBrandManagement();
      case 'Shop Management':
        return _buildShopManagement();
      case 'Staff Management':
        return _buildStaffManagement();
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_menuItems[_selectedMenuIndex]['icon'], size: 64, color: AppColors.textHint),
              const SizedBox(height: 16),
              Text(
                '${_menuItems[_selectedMenuIndex]['title']} Content',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const Text('This feature is coming soon in the next update.', style: TextStyle(color: AppColors.textHint)),
            ],
          ),
        );
    }
  }

  Widget _buildDrawerHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildShopManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Master Shop Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          const Text(
            'High-level administrative controls for TechPlumb Solutions.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 24),
          _buildShopAdminCard(
            'Service Availability',
            'Enable or disable shop services globally.',
            Icons.power_settings_new,
            Colors.green,
            true,
          ),
          _buildShopAdminCard(
            'Inventory Sync',
            'Force manual synchronization with master database.',
            Icons.sync,
            Colors.blue,
            false,
          ),
          _buildShopAdminCard(
            'Maintenance Mode',
            'Place the mobile app in maintenance mode for updates.',
            Icons.construction,
            Colors.orange,
            false,
          ),
          _buildShopAdminCard(
            'Data Backup',
            'Generate and email the latest database backup.',
            Icons.backup_outlined,
            Colors.purple,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildShopAdminCard(String title, String desc, IconData icon, Color color, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(desc, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: isActive,
            onChanged: (v) {},
            activeColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard('Total Products', '1,247', Icons.inventory_2_outlined, Colors.blue),
              const SizedBox(width: 12),
              _buildStatCard('Active Staff', '8', Icons.people_outline, Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Pending Verifications', '2', Icons.verified_user_outlined, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Recent Activity Logs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          _buildActivityLog('Added new product: Havells Adonia R 25L', '2 hours ago', Icons.add_box_outlined, Colors.blue),
          _buildActivityLog('Updated specifications for Philips 12W LED', '4 hours ago', Icons.edit_note_outlined, Colors.orange),
          _buildActivityLog('New staff account created: Rahul', 'Yesterday', Icons.person_add_alt_1_outlined, Colors.green),
          _buildActivityLog('Shop contact details updated', '2 days ago', Icons.storefront_outlined, Colors.purple),
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
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLog(String title, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductUploadForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          _buildTextField('Product Name', 'e.g. Havells Adonia R'),
          const SizedBox(height: 16),
          _buildTextField('Product Model', 'e.g. ADONIA-R-25'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Brand', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showSearchablePicker(
                        title: 'Select Brand',
                        options: _brands,
                        onSelected: (val) => setState(() => _selectedBrand = val),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedBrand, style: const TextStyle(fontSize: 14)),
                            const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Category', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showSearchablePicker(
                        title: 'Select Category',
                        options: const ['Electrical', 'Plumbing', 'Lighting', 'Pipes', 'Tools', 'Bathroom Fittings'],
                        onSelected: (val) => setState(() => _selectedCategory = val),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedCategory, style: const TextStyle(fontSize: 14)),
                            const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Image Upload Section
          const Text('Product Image', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 32),
                const SizedBox(height: 8),
                const Text('Upload Product Image', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                Text('Max size: 500KB (JPG/PNG)', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Technical Specifications
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Technical Specifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => setState(() => _tempSpecs.add({'label': '', 'value': ''})),
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
              ),
            ],
          ),
          ..._tempSpecs.asMap().entries.map((entry) {
            int idx = entry.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Label (e.g. Capacity)', fillColor: Colors.grey[50]),
                      onChanged: (v) => _tempSpecs[idx]['label'] = v,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Value (e.g. 25L)', fillColor: Colors.grey[50]),
                      onChanged: (v) => _tempSpecs[idx]['value'] = v,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _tempSpecs.removeAt(idx)),
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // Key Features
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Key Features', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                onPressed: () => setState(() => _tempFeatures.add('')),
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
              ),
            ],
          ),
          ..._tempFeatures.asMap().entries.map((entry) {
            int idx = entry.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(hintText: 'Feature description', fillColor: Colors.grey[50]),
                      onChanged: (v) => _tempFeatures[idx] = v,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _tempFeatures.removeAt(idx)),
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // Warranty Input
          _buildTextField('Warranty Information', 'e.g. 2 Years Product warranty'),
          
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _isAddingProduct = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product details saved and uploaded!')),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save & Publish Product', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBrandManagement() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Brand Directory',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              ElevatedButton.icon(
                onPressed: () => _showBrandDialog(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Brand'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ..._brands.map((brand) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), shape: BoxShape.circle),
                      child: const Icon(Icons.branding_watermark, size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(brand, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
                      onPressed: () => _showBrandDialog(oldName: brand),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _brands.remove(brand);
                          if (_selectedBrand == brand) _selectedBrand = _brands.isNotEmpty ? _brands.first : '';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$brand removed.')));
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _showBrandDialog({String? oldName}) {
    final TextEditingController controller = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(oldName == null ? 'Add New Brand' : 'Edit Brand'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter brand name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  if (oldName == null) {
                    _brands.add(controller.text);
                  } else {
                    int index = _brands.indexOf(oldName);
                    _brands[index] = controller.text;
                    if (_selectedBrand == oldName) _selectedBrand = controller.text;
                  }
                  _brands.sort();
                });
                Navigator.pop(context);
              }
            },
            child: Text(oldName == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffManagement() {
    final List<Map<String, String>> staffList = [
      {'name': 'Rahul Kumar', 'role': 'Sales Executive', 'status': 'Active'},
      {'name': 'Nihal Ahmed', 'role': 'Inventory Manager', 'status': 'Active'},
      {'name': 'Suresh Raina', 'role': 'Support Staff', 'status': 'Inactive'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Staff Directory',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() => _isAddingStaff = true),
                icon: const Icon(Icons.person_add_alt_1, size: 18),
                label: const Text('Create Account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...staffList.map((staff) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(staff['name']![0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(staff['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(staff['role']!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: staff['status'] == 'Active' ? Colors.green[50] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            staff['status']!,
                            style: TextStyle(
                              color: staff['status'] == 'Active' ? Colors.green : Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => setState(() => _viewingActivityFor = staff['name']),
                          icon: const Icon(Icons.history, size: 16),
                          label: const Text('Activity', style: TextStyle(fontSize: 12)),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Edit', style: TextStyle(fontSize: 12)),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${staff['name']} has been ${staff['status'] == 'Active' ? 'deactivated' : 'activated'}.')),
                            );
                          },
                          icon: Icon(staff['status'] == 'Active' ? Icons.block : Icons.check_circle_outline, size: 16, color: Colors.red),
                          label: Text(
                            staff['status'] == 'Active' ? 'Deactivate' : 'Activate',
                            style: const TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStaffForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Staff Account',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 20),
          _buildTextField('Full Name', 'e.g. John Doe'),
          const SizedBox(height: 16),
          _buildTextField('Email Address', 'e.g. john@techplumb.com'),
          const SizedBox(height: 16),
          _buildTextField('Role', 'e.g. Sales Executive'),
          const SizedBox(height: 16),
          _buildTextField('Temporary Password', 'Create a secure password'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() => _isAddingStaff = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Staff account created successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
              child: const Text('Create Account'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffActivityView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              const Icon(Icons.person_outline, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                'Activity History: $_viewingActivityFor',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildActivityLog('Updated product: MCB 16A Schneider', '1 hour ago', Icons.edit_note, Colors.orange),
              _buildActivityLog('Viewed "Havells Adonia" details', '3 hours ago', Icons.visibility_outlined, Colors.blue),
              _buildActivityLog('Performed barcode scan scan: PRD772', '4 hours ago', Icons.qr_code_scanner, Colors.green),
              _buildActivityLog('Modified profile details', 'Yesterday', Icons.manage_accounts, Colors.purple),
            ],
          ),
        ),
      ],
    );
  }

  void _showSearchablePicker({
    required String title,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SearchablePickerModal(
        title: title,
        options: options,
        onSelected: onSelected,
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }
}

class _SearchablePickerModal extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(String) onSelected;

  const _SearchablePickerModal({
    required this.title,
    required this.options,
    required this.onSelected,
  });

  @override
  State<_SearchablePickerModal> createState() => _SearchablePickerModalState();
}

class _SearchablePickerModalState extends State<_SearchablePickerModal> {
  late List<String> _filteredOptions;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
  }

  void _filterOptions(String query) {
    setState(() {
      _filteredOptions = widget.options
          .where((option) => option.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterOptions,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: _filteredOptions.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredOptions[index]),
                  onTap: () {
                    widget.onSelected(_filteredOptions[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
