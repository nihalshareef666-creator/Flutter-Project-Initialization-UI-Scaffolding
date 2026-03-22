import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/user_model.dart';

class AdministratorDashboard extends StatefulWidget {
  final User user;
  const AdministratorDashboard({super.key, required this.user});

  @override
  State<AdministratorDashboard> createState() => _AdministratorDashboardState();
}

class _AdministratorDashboardState extends State<AdministratorDashboard> {
  int _selectedMenuIndex = 0;
  final Color masterColor = Colors.deepPurple;
  final Color accentColor = const Color(0xFF7E57C2);

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'Dashboard Overview', 'icon': Icons.dashboard_customize_outlined},
    {'title': 'Shop Management', 'icon': Icons.business_center_outlined},
    {'title': 'Verification Requests', 'icon': Icons.verified_user_outlined},
    {'title': 'All Shops List', 'icon': Icons.format_list_bulleted_rounded},
    {'title': 'User Management', 'icon': Icons.manage_accounts_outlined},
    {'title': 'System Activity Logs', 'icon': Icons.history_edu_outlined},
    {'title': 'Platform Monitoring', 'icon': Icons.monitor_heart_outlined},
    {'title': 'Logout', 'icon': Icons.logout, 'color': Colors.redAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrator Master Terminal'),
        backgroundColor: masterColor,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.security, size: 20)),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: Icon(Icons.developer_mode, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 16),
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
            decoration: BoxDecoration(color: masterColor),
            accountName: Text(widget.user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.deepPurple, size: 40),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final isSelected = _selectedMenuIndex == index;
                final color = item['color'] ?? (isSelected ? masterColor : AppColors.textSecondary);

                return ListTile(
                  leading: Icon(item['icon'], color: color),
                  title: Text(
                    item['title'],
                    style: TextStyle(
                      color: item['color'] ?? (isSelected ? masterColor : AppColors.textPrimary),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: masterColor.withOpacity(0.05),
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
            child: Text('v2.0.4-stable-prod', style: TextStyle(color: Colors.grey, fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final title = _menuItems[_selectedMenuIndex]['title'];
    switch (title) {
      case 'Dashboard Overview':
        return _buildOverview();
      case 'Verification Requests':
        return _buildShopRequests();
      case 'All Shops List':
        return _buildAllShopsList();
      case 'Shop Management':
        return _buildShopManagement();
      case 'User Management':
        return _buildUserManagement();
      case 'System Activity Logs':
        return _buildActivityLogs();
      case 'Platform Monitoring':
        return _buildMonitoring();
      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_menuItems[_selectedMenuIndex]['icon'], size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                '${_menuItems[_selectedMenuIndex]['title']} coming soon',
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildShopManagement() => _buildPlaceholder('Shop Management Tools');
  Widget _buildUserManagement() => _buildPlaceholder('User Access Control');
  Widget _buildActivityLogs() => _buildPlaceholder('System Event Audit');
  Widget _buildMonitoring() => _buildPlaceholder('Infrastructure Status');

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 48, color: masterColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Module integration in progress...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome, ${widget.user.name}', style: TextStyle(color: masterColor, fontWeight: FontWeight.bold, fontSize: 14)),
          const Text('System Statistics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard('Total Shops', '248', Icons.store, Colors.blue),
              const SizedBox(width: 12),
              _buildStatCard('Active Users', '12.4K', Icons.people, Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Platform Revenue', '42.8K', Icons.account_balance_wallet, Colors.orange),
              const SizedBox(width: 12),
              _buildStatCard('System Health', '99.9%', Icons.speed, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          _buildCriticalAlerts(),
          const SizedBox(height: 24),
          const Text('Recent Platform Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildEventLog('New Shop: Green Valley Electricals registered', '10m ago', Icons.add_business, Colors.blue),
          _buildEventLog('Verification failed: Bright Lights Ltd (Invalid KYC)', '1h ago', Icons.error_outline, Colors.red),
          _buildEventLog('System Backup completed successfully', '4h ago', Icons.cloud_done, Colors.green),
          _buildEventLog('Server load reached 85% at Asia-South-1', '6h ago', Icons.warning_amber, Colors.orange),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildCriticalAlerts() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.gpp_maybe, color: Colors.red),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Critical Security Alert', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                Text('3 unidentified login attempts blocked in the last 15 minutes.', style: TextStyle(color: Colors.red, fontSize: 12)),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('VIEW', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildEventLog(String msg, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 20)),
        title: Text(msg, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        subtitle: Text(time, style: const TextStyle(fontSize: 11)),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.divider)),
      ),
    );
  }

  Widget _buildShopRequests() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.store, color: Colors.white)),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Techno Power Solutions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Owner: Sameer Malhotra', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text('Business Type: Electrical Retail & Service', style: TextStyle(fontSize: 13)),
                const Text('Location: Mumbai, Maharashtra', style: TextStyle(fontSize: 13)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(onPressed: () {}, child: const Text('REJECT', style: TextStyle(color: Colors.red))),
                    const SizedBox(width: 12),
                    ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('APPROVE')),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildAllShopsList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Shop Name', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          _buildDataRow('TechPlumb HQ', 'Admin', 'Verified', Colors.green),
          _buildDataRow('Global Pipes', 'Admin', 'Pending', Colors.orange),
          _buildDataRow('LiteUp World', 'Admin', 'Blocked', Colors.red),
        ],
      ),
    );
  }

  DataRow _buildDataRow(String name, String role, String status, Color statusColor) {
    return DataRow(cells: [
      DataCell(Text(name)),
      DataCell(Text(role)),
      DataCell(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
        child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
      )),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.visibility_outlined, size: 18), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () {}),
        ],
      )),
    ]);
  }
}
