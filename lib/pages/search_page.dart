import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testpro26/main.dart';
import 'package:go_router/go_router.dart';
import 'package:testpro26/providers/product_provider.dart';
import 'package:testpro26/models/product_model.dart';

class SearchPage extends StatefulWidget {
  final bool isComparisonMode;
  const SearchPage({super.key, this.isComparisonMode = false});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isSearching = false;
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Electrical',
    'Plumbing',
    'Lighting',
    'Pipes',
    'Bathroom Fittings',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _performSearch(query);
  }

  void _performSearch(String query) async {
    if (query.isEmpty && _selectedFilter == 'All') {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    
    try {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      final results = await provider.searchProducts(query);
      
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = _selectedFilter == 'All' 
              ? results 
              : results.where((p) => p.category.toLowerCase().contains(_selectedFilter.toLowerCase())).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = [];
        });
      }
    }
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
              child: _buildContent(),
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
                  hintText: 'Search product, brand, or barcode...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
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
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
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
    if (_searchResults.isEmpty && (_searchController.text.isNotEmpty || _selectedFilter != 'All')) {
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

  Widget _buildProductCard(Product p, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isComparisonMode) {
          Provider.of<ProductProvider>(context, listen: false).addToComparison(p);
          context.pop();
        } else {
          context.push('/product/${p.barcode}');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
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
              child: const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        p.brand,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.category,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      Spacer(),
                      Text(
                        'View Details',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: AppColors.primary,
                      ),
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
          const Text(
            'Search Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Find electrical and plumbing solutions',
            style: TextStyle(color: AppColors.textSecondary),
          ),
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
          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          if (_searchController.text.isNotEmpty)
            Text(
              'for "${_searchController.text}"',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }
}
