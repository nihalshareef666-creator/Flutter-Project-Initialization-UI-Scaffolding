import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  final Function(User) onSave;

  const EditProfilePage({super.key, required this.user, required this.onSave});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = widget.user.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      widget.onSave(updatedUser);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdministrator = widget.user.role == UserRole.administrator;
    final Color themeColor = isAdministrator ? const Color(0xFF673AB7) : AppColors.primary;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: themeColor,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: themeColor, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          widget.user.name[0],
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: themeColor),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              _buildFieldLabel('Full Name'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Enter your full name'),
                validator: (value) => (value == null || value.isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 20),

              _buildFieldLabel('Email Address'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildFieldLabel('Phone Number'),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: 'Enter your phone number'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Phone number is required';
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Phone must contain only numbers';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              if (widget.user.shopName != null) ...[
                _buildFieldLabel('Shop Name (Read Only)'),
                TextFormField(
                  initialValue: widget.user.shopName,
                  enabled: false,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary)),
    );
  }
}
