import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/user_model.dart';
import 'package:testpro26/pages/ai_recommendations_page.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final bool isAdministrator = user?.role == UserRole.administrator;
    final Color themeColor = isAdministrator ? const Color(0xFF673AB7) : AppColors.primary;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HomeAppBar(user: user, themeColor: themeColor),
          if (isAdministrator) ...[
            const SizedBox(height: 20),
            _AdminStatsSection(),
            const SizedBox(height: 20),
            _AdminQuickActions(),
          ],
          const SizedBox(height: 20),
          _StatsSection(isAdministrator: isAdministrator),
          const SizedBox(height: 24),
          _CategoriesSection(),
          const SizedBox(height: 24),
          _RecentProductsSection(),
          const SizedBox(height: 24),
          _AIRecommendedSection(),
          const SizedBox(height: 24),
          _QuickButtonsSection(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ─── App Bar ──────────────────────────────────────────────────
class _HomeAppBar extends StatelessWidget {
  final User? user;
  final Color themeColor;
  const _HomeAppBar({this.user, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (user?.role == UserRole.administrator || user?.role == UserRole.admin)
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if (user?.role == UserRole.administrator || user?.role == UserRole.admin)
                    const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TechPlumb Solutions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Precision in every part',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_outlined, color: Colors.white),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Search Field
          GestureDetector(
            onTap: () {
              // Action bypassed
            },
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: AppColors.textSecondary),
                  SizedBox(width: 12),
                  Text(
                    'Search products, brand or specs...',
                    style: TextStyle(color: AppColors.textHint, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Section ────────────────────────────────────────────
class _StatsSection extends StatelessWidget {
  final bool isAdministrator;
  const _StatsSection({this.isAdministrator = false});

  @override
  Widget build(BuildContext context) {
    final Color themeColor = isAdministrator ? const Color(0xFF673AB7) : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.inventory_2, color: themeColor, size: 30),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Products Available',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '1,247',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Categories ───────────────────────────────────────────────
class _CategoriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> _categories = [
    {'label': 'Electrical', 'icon': Icons.bolt, 'color': Colors.blue},
    {'label': 'Plumbing', 'icon': Icons.water_drop, 'color': Colors.cyan},
    {'label': 'Lighting', 'icon': Icons.lightbulb, 'color': Colors.amber},
    {'label': 'Pipes', 'icon': Icons.horizontal_distribute, 'color': Colors.indigo},
    {'label': 'Tools', 'icon': Icons.build, 'color': Colors.orange},
    {'label': 'Bathroom Fittings', 'icon': Icons.bathtub_outlined, 'color': Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Explore Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              return _CategoryItem(
                label: cat['label'],
                icon: cat['icon'],
                color: cat['color'],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _CategoryItem({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recent Products ──────────────────────────────────────────
class _RecentProductsSection extends StatelessWidget {
  final List<Map<String, String>> _recent = [
    {'name': 'Havells Adonia R 25L', 'category': 'Electrical'},
    {'name': 'Schneider MCB 1 Pole', 'category': 'Electrical'},
    {'name': 'Philips 12W LED', 'category': 'Lighting'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recently Viewed',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Clear All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _recent.length,
            itemBuilder: (context, index) {
              final p = _recent[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(p['category']!, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Quick View', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
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

// ─── AI Recommended ──────────────────────────────────────────
class _AIRecommendedSection extends StatelessWidget {
  final List<Map<String, String>> _recommended = [
    {
      'name': 'Havells Adonia R',
      'brand': 'Havells',
      'specs': '25L, 5 Star, WiFi',
      'tag': 'Best Efficiency'
    },
    {
      'name': 'Jaquar Alive Faucet',
      'brand': 'Jaquar',
      'specs': 'Chrome, Single Lever',
      'tag': 'Premium Design'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'AI Recommended',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIProductRecommendationPage()),
                  );
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _recommended.length,
            itemBuilder: (context, index) {
              final p = _recommended[index];
              return Container(
                width: 220,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.orange.withOpacity(0.05), blurRadius: 10, spreadRadius: 2),
                  ],
                  border: Border.all(color: Colors.orange.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(p['brand']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                          child: Text(p['tag']!, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.orange)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      p['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(p['specs']!, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Spacer(),
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

// ─── Administrator Sections ───────────────────────────────────
class _AdminStatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Administrator Dashboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF673AB7)),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.8,
            children: [
              _simpleStatCard('Total Shops', '24', Icons.store, Colors.blue),
              _simpleStatCard('Pending Requests', '12', Icons.verified_user, Colors.orange),
              _simpleStatCard('Total Products', '12,482', Icons.inventory_2, Colors.green),
              _simpleStatCard('Total Users', '1,482', Icons.people, Colors.teal),
              _simpleStatCard('Activity Logs', '189', Icons.history, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _simpleStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _AdminQuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _quickActionIcon(Icons.business_center, 'Shops'),
          _quickActionIcon(Icons.how_to_reg, 'Verify'),
          _quickActionIcon(Icons.people_alt, 'Users'),
          _quickActionIcon(Icons.terminal, 'Logs'),
        ],
      ),
    );
  }

  Widget _quickActionIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF673AB7).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.business_center, color: Color(0xFF673AB7), size: 24),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ─── Quick Buttons ────────────────────────────────────────────
class _QuickButtonsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Operations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _QuickButton(
            title: 'Barcode Scanner',
            subtitle: 'Scan product for quick info',
            icon: Icons.qr_code_scanner,
            color: Colors.indigo,
            onTap: () {
              context.push('/scanner');
            },
          ),
          const SizedBox(height: 12),
          _QuickButton(
            title: 'Product Comparison',
            subtitle: 'Compare up to 3 products',
            icon: Icons.compare_arrows,
            color: Colors.teal,
            onTap: () {
              context.push('/compare');
            },
          ),
        ],
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

