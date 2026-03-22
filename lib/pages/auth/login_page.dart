import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/user_model.dart';

class LoginPage extends StatefulWidget {
  final Function(User) onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers removed to clean up unused warnings as role selection is used for demo


  void _login(UserRole role) {
    // Simulated login based on selected role for demo purposes
    String name = '';
    String email = '';
    String phone = '';
    String? shopName;
    String? shopId;

    switch (role) {
      case UserRole.administrator:
        name = 'Tech Support';
        email = 'support@techplumb.com';
        phone = '+1 555-010-999';
        break;
      case UserRole.admin:
        name = 'Nihal Owner';
        email = 'owner@techplumb.com';
        phone = '+91 9876543210';
        shopName = 'TechPlumb Solutions HQ';
        shopId = 'SHOP_001';
        break;
      case UserRole.staff:
        name = 'Rahul Sharma';
        email = 'rahul@techplumb.com';
        phone = '+91 8887776660';
        shopName = 'TechPlumb Solutions HQ';
        shopId = 'SHOP_001';
        break;
      case UserRole.customer:
        name = 'John Doe';
        email = 'john.doe@example.com';
        phone = '+1 202-555-0143';
        break;
    }

    widget.onLoginSuccess(User(
      name: name,
      email: email,
      phone: phone,
      shopName: shopName,
      shopId: shopId,
      role: role,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.storefront, size: 80, color: AppColors.primary),
              const SizedBox(height: 16),
              const Text(
                'TechPlumb Solutions',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enterprise Resource Planning',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 48),
              
              const Text(
                'Select Role for Demo Login',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              
              _buildRoleButton('Administrator (Dev)', UserRole.administrator, Colors.deepPurple),
              _buildRoleButton('Admin (Shop Owner)', UserRole.admin, AppColors.primary),
              _buildRoleButton('Staff (Employee)', UserRole.staff, Colors.teal),
              _buildRoleButton('Customer (User)', UserRole.customer, Colors.orange),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                '© 2026 TechPlumb Solutions',
                style: TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(String label, UserRole role, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () => _login(role),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}
