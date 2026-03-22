import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _suggestions = [];
  bool _isSearching = false;
  String _selectedFilter = 'All';

  static const _allProducts = [
    {
      'name': 'Havells Adonia R 25L Water Heater',
      'brand': 'Havells',
      'sku': 'PRD1001',
      'category': 'Electrical',
      'stock': true,
      'specs': '25L, 5 Star BEE',
      'features': 'IoT Enabled, WiFi',
    },
    {
      'name': '1 Pole 16A MCB Schneider',
      'brand': 'Schneider',
      'sku': 'PRD1002',
      'category': 'Electrical',
      'stock': true,
      'specs': '1 Pole, 16A, Type C',
      'features': 'Fast Tripping',
    },
    {
      'name': 'V-Guard Calisto 25L Water Heater',
      'brand': 'V-Guard',
      'sku': 'PRD1003',
      'category': 'Electrical',
      'stock': false,
      'specs': '25L, 4 Star BEE',
      'features': 'Anti-corrosive tank',
    },
    {
      'name': 'Legrand Arteor Switch 6A White',
      'brand': 'Legrand',
      'sku': 'PRD1004',
      'category': 'Switches',
      'stock': true,
      'specs': '6A, 1 Way, Modular',
      'features': 'Child Safe',
    },
    {
      'name': 'PVC Water Pipe 32mm',
      'brand': 'Finolex',
      'sku': 'PRD1005',
      'category': 'Plumbing',
      'stock': true,
      'specs': '32mm, 6kgf/cm2',
      'features': 'Lead Free',
    },
    {
      'name': 'LED Ceiling Light 18W',
      'brand': 'Philips',
      'sku': 'PRD1006',
      'category': 'Lighting',
      'stock': true,
      'specs': '18W, 6500K, Neutral White',
      'features': 'EyeComfort Tech',
    },
    {
      'name': 'Bathroom Faucet Chrome',
      'brand': 'Jaquar',
      'sku': 'PRD1007',
      'category': 'Bathroom Fittings',
      'stock': false,
      'specs': 'Chrome Finish, Single Lever',
      'features': 'Foam Flow',
    },
  ];

  static const _filters = ['All', 'Electrical', 'Plumbing', 'Lighting', 'Bathroom Fittings'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _suggestions = _allProducts
          .where((p) => (p['name'] as String).toLowerCase().contains(query.toLowerCase()))
          .map((p) => p['name'] as String)
          .take(5)
          .toList();
    });

    _performSearch(query);
  }

  void _performSearch(String query) {
    setState(() => _isSearching = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      setState(() {
        _isSearching = false;
        _searchResults = _allProducts.where((p) {
          final matchesQuery = (p['name'] as String).toLowerCase().contains(query.toLowerCase()) ||
              (p['brand'] as String).toLowerCase().contains(query.toLowerCase()) ||
              (p['sku'] as String).toLowerCase().contains(query.toLowerCase());
          final matchesFilter = _selectedFilter == 'All' || p['category'] == _selectedFilter;
          return matchesQuery && matchesFilter;
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(),
            _buildFilterBar(),
            Expanded(
              child: Stack(
                children: [
                   _buildContent(),
                   if (_suggestions.isNotEmpty && _searchController.text.isNotEmpty)
                     _buildSuggestionsOverlay(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search brand, category, specs...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: AppColors.primary, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 56,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (val) {
                setState(() => _selectedFilter = filter);
                _performSearch(_searchController.text);
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary.withOpacity(0.12),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: isSelected ? AppColors.primary : AppColors.divider),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return _buildNoResults();
    }
    if (_searchResults.isEmpty) {
      return _buildEmptyState();
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final p = _searchResults[index];
        return _buildProductCard(p, context);
      },
    );
  }

  Widget _buildSuggestionsOverlay() {
    return Positioned(
      top: 0,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _suggestions.map((s) => ListTile(
              leading: const Icon(Icons.history, size: 20, color: AppColors.textHint),
              title: Text(s, style: const TextStyle(fontSize: 14)),
              onTap: () {
                _searchController.text = s;
                _onSearchChanged(s);
              },
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> p, BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/product-details/890123456789');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: AppColors.textHint),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p['brand'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: p['stock'] ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          p['stock'] ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(color: p['stock'] ? Colors.green : Colors.red, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(p['specs'], style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 12, color: Colors.amber[700]),
                      const SizedBox(width: 4),
                      Text(p['features'] ?? 'Premium Quality', style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      const Text('View Details', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                      const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Search Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Text('Find electrical and plumbing solutions', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No products found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          Text('for "${_searchController.text}"', style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

