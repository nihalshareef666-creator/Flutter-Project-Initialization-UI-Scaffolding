import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/user_model.dart';
import 'package:testpro26/pages/edit_profile_page.dart';
import 'package:testpro26/pages/auth/change_password_page.dart';
import 'package:testpro26/pages/my_added_products_page.dart';
import 'package:testpro26/pages/admin/staff_management_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;
  final Function(User) onUpdateUser;

  const ProfilePage({
    super.key,
    required this.user,
    required this.onLogout,
    required this.onUpdateUser,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _emailNotif = true;

  User get _user => widget.user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── App Bar ──────────────────────────────────────────
        Container(
          color: _getRoleColor(_user.role),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.storefront, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'E&P Retail',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (_user.role == UserRole.administrator || _user.role == UserRole.admin)
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ── Profile hero ─────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(0.1),
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: const Icon(Icons.person, size: 40, color: AppColors.primary),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                              child: const Icon(Icons.photo_camera, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _user.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _user.email,
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                            ),
                            const SizedBox(height: 10),
                            // Role Color Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getRoleColor(_user.role),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '[ ${_user.role.name.toUpperCase()} ]',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            if (_user.shopName != null && (_user.role == UserRole.admin || _user.role == UserRole.staff)) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    _user.role == UserRole.staff ? Icons.badge_outlined : Icons.store_outlined,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _user.role == UserRole.staff 
                                      ? 'Staff – ${_user.shopName!}'
                                      : 'Shop: ${_user.shopName!}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // ── Role Based Quick Actions ─────────────────
                if (_user.role == UserRole.administrator) ...[
                  _SectionHeader('Administrator Controls'),
                  _MenuTile(
                    icon: Icons.business_center_outlined,
                    color: Colors.deepPurple,
                    title: 'Shop Management',
                    subtitle: 'Manage all shops on platform',
                    onTap: () => _snack('Opening shop management...'),
                  ),
                  _MenuTile(
                    icon: Icons.verified_user_outlined,
                    color: Colors.deepPurple,
                    title: 'Verification Requests',
                    subtitle: 'Approve or reject KYC requests',
                    onTap: () => _snack('Opening verification requests...'),
                  ),
                  _MenuTile(
                    icon: Icons.inventory_2_outlined,
                    color: Colors.deepPurple,
                    title: 'Product Master',
                    subtitle: 'Manage all products in system',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyAddedProductsPage(user: _user)),
                      );
                    },
                  ),
                  _MenuTile(
                    icon: Icons.manage_accounts_outlined,
                    color: Colors.deepPurple,
                    title: 'Staff Management (System)',
                    subtitle: 'Manage staff across all shops',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => StaffManagementPage(user: _user)),
                      );
                    },
                  ),
                  _MenuTile(
                    icon: Icons.history_edu_outlined,
                    color: Colors.deepPurple,
                    title: 'System Logs',
                    subtitle: 'Audit platform activity',
                    onTap: () => _snack('Opening activity logs...'),
                  ),
                  _MenuTile(
                    icon: Icons.settings_suggest_outlined,
                    color: Colors.deepPurple,
                    title: 'Platform Settings',
                    subtitle: 'Adjust general app configurations',
                    onTap: () => _snack('Opening platform settings...'),
                  ),
                  const SizedBox(height: 8),
                ],
                if (_user.role == UserRole.admin || _user.role == UserRole.staff) ...[
                  _SectionHeader('Management'),
                  if (_user.role == UserRole.admin) ...[
                    _MenuTile(
                      icon: Icons.store_outlined,
                      color: Colors.teal,
                      title: 'Shop Details',
                      subtitle: 'Update shop information',
                      onTap: () => _snack('Opening shop details...'),
                    ),
                    _MenuTile(
                      icon: Icons.people_outline,
                      color: Colors.blue,
                      title: 'Staff Management',
                      subtitle: 'Manage your team',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => StaffManagementPage(user: _user)),
                        );
                      },
                    ),
                    _MenuTile(
                      icon: Icons.inventory_2_outlined,
                      color: Colors.blue,
                      title: 'Product Management',
                      subtitle: 'Manage shop products',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MyAddedProductsPage(user: _user)),
                        );
                      },
                    ),
                  ],
                  if (_user.role == UserRole.staff)
                    _MenuTile(
                      icon: Icons.inventory_2_outlined,
                      color: Colors.green,
                      title: 'My Added Products',
                      subtitle: '23 products added',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => MyAddedProductsPage(user: _user)),
                        );
                      },
                    ),
                  const SizedBox(height: 8),
                ],

                // ── Account Settings ──────────────────────────
                _SectionHeader('Account Settings'),
                _MenuTile(
                  icon: Icons.person_outline,
                  color: AppColors.primary,
                  title: 'Edit Profile',
                  subtitle: 'Change your personal details',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfilePage(
                          user: _user,
                          onSave: (updatedUser) {
                            widget.onUpdateUser(updatedUser);
                            _snack('Profile Updated Successfully');
                          },
                        ),
                      ),
                    );
                  },
                ),
                _MenuTile(
                  icon: Icons.lock_outline,
                  color: Colors.orange,
                  title: 'Change Password',
                  subtitle: 'Update your security credentials',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangePasswordPage(
                          user: _user,
                          onPasswordChanged: widget.onLogout,
                        ),
                      ),
                    );
                  },
                ),
                
                // ── Notifications Section ──
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _ToggleTile(
                        icon: Icons.notifications_none,
                        color: Colors.indigo,
                        title: 'Notification Settings',
                        subtitle: 'Manage app alerts',
                        value: _emailNotif,
                        onChanged: (v) => setState(() => _emailNotif = v),
                      ),
                    ],
                  ),
                ),
                _MenuTile(
                  icon: Icons.logout,
                  color: AppColors.error,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  onTap: _showLogoutDialog,
                ),
                
                const SizedBox(height: 32),

                // ── App Information ──────────────────────────
                _SectionHeader('App Information'),
                _MenuTile(
                  icon: Icons.info_outline,
                  color: Colors.blueGrey,
                  title: 'About App',
                  subtitle: 'TechPlumb Solutions v1.2',
                  onTap: () => _snack('About TechPlumb Solutions'),
                ),
                _MenuTile(
                  icon: Icons.privacy_tip_outlined,
                  color: Colors.blueGrey,
                  title: 'Privacy Policy',
                  subtitle: 'Standard enterprise terms',
                  onTap: () => _snack('Privacy Policy'),
                ),
                _MenuTile(
                  icon: Icons.help_outline,
                  color: Colors.blueGrey,
                  title: 'Help & Support',
                  subtitle: 'Staff assistance & guidelines',
                  onTap: () => _snack('Opening help desk...'),
                ),
                _MenuTile(
                  icon: Icons.verified_outlined,
                  color: Colors.grey,
                  title: 'App Version',
                  subtitle: '1.2.0 stable (enterprise)',
                  onTap: null,
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.administrator: return Colors.deepPurple;
      case UserRole.admin: return Colors.blue;
      case UserRole.staff: return Colors.green;
      case UserRole.customer: return Colors.orange;
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onLogout();
              _snack('Logged out successfully. Session cleared.');
            },
            child: const Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      width: double.infinity,
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const _MenuTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: backgroundColor ?? color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
                ],
              ),
            ),
            const Divider(height: 1, indent: 66),
          ],
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeThumbColor: AppColors.primary),
        ],
      ),
    );
  }
}
