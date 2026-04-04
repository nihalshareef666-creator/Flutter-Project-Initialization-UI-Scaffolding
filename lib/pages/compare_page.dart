import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/product_model.dart';
import 'package:testpro26/providers/product_provider.dart';
import 'package:go_router/go_router.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final selectedProducts = provider.comparisonList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Compare Products'),
        actions: [
          if (selectedProducts.isNotEmpty)
            TextButton(
              onPressed: () => provider.clearComparison(),
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (selectedProducts.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                color: Colors.white,
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      'Comparing ${selectedProducts.length} products (Max 4)',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: selectedProducts.isEmpty
                  ? _buildEmptyState(context)
                  : _buildComparisonView(context, selectedProducts, provider),
            ),
          ],
        ),
      ),
      floatingActionButton: selectedProducts.isNotEmpty && selectedProducts.length < 4
          ? FloatingActionButton.extended(
              onPressed: () => _showAddComparisonBottomSheet(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Comparison', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.compare_arrows_rounded, size: 80, color: AppColors.primary.withOpacity(0.2)),
            ),
            const SizedBox(height: 24),
            const Text(
              'No products selected for comparison',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Add products from the scanner or product details to compare them side-by-side.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _showAddComparisonBottomSheet(context),
                icon: const Icon(Icons.add),
                label: const Text('Add Comparison'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddComparisonBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Product to Comparison',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.search, color: AppColors.primary),
                ),
                title: const Text('Search Product', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Find products by name or brand'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/search?compare=true');
                },
              ),
              const Divider(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.qr_code_scanner, color: Colors.orange),
                ),
                title: const Text('QR Scan', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Scan product barcode'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/scanner?compare=true');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComparisonView(BuildContext context, List<Product> products, ProductProvider provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTableHeader(products, provider),
                const SizedBox(height: 8),
                _buildTableBody(products),
              ],
            ),
          ),
          _buildAiRecommendationSection(context, products, provider),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAiRecommendationSection(BuildContext context, List<Product> products, ProductProvider provider) {
    if (products.length < 2) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AI Recommendation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (!provider.isLoading)
                TextButton.icon(
                  onPressed: () async {
                    final response = await provider.getAiProductComparison();
                    if (response != null && context.mounted) {
                      _showRecommendationDialog(context, response);
                    }
                  },
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Get AI Insight'),
                ),
            ],
          ),
        ),
        if (provider.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                children: [
                  CircularProgressIndicator(strokeWidth: 2),
                  SizedBox(height: 12),
                  Text('AI is analyzing products...'),
                ],
              ),
            ),
          )
        else if (provider.error != null)
          _buildErrorWidget(provider.error!)
        else
          _buildStaticComparisonCard(products),
      ],
    );
  }

  void _showRecommendationDialog(BuildContext context, String recommendation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.auto_awesome, color: AppColors.primary),
            SizedBox(width: 8),
            Text('AI Comparison Result'),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(recommendation),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(child: Text(error, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildStaticComparisonCard(List<Product> products) {
    // Standard mock for when AI hasn't been called yet or as a fallback
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Ready for AI Insight',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Click "Get AI Insight" above to generate a smart comparison between these products using OpenRouter.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTableHeader(List<Product> products, ProductProvider provider) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCell('Attributes', isHeader: true, width: 120),
          ...products.map((p) => _buildProductHeaderCell(p, provider)),
        ],
      ),
    );
  }

  Widget _buildProductHeaderCell(Product p, ProductProvider provider) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_outlined, color: AppColors.textHint, size: 30),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => provider.removeFromComparison(p.barcode),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                    child: const Icon(Icons.close, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            p.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            p.brand,
            style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTableBody(List<Product> products) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildComparisonRow('Category', products, (p) => p.category),
          _buildComparisonRow('Barcode', products, (p) => p.barcode),
          _buildComparisonRow('Price', products, (p) => '\$${p.price.toStringAsFixed(2)}'),
          _buildComparisonRow('Rating', products, (p) => '${p.rating} / 5.0'),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String title, List<Product> products, String Function(Product) getValue) {
    final values = products.map((p) => getValue(p)).toList();
    // Check if there are differences to highlight (only if > 1 product)
    final bool hasDifference = products.length > 1 && values.toSet().length > 1;

    return Container(
      decoration: BoxDecoration(
        color: hasDifference ? AppColors.primary.withOpacity(0.03) : Colors.white,
        border: const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _buildCell(title, isHeader: true, width: 120),
          ...products.map((p) => _buildCell(
                getValue(p),
                width: 160,
                isHighlighted: hasDifference,
              )),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {bool isHeader = false, bool isHighlighted = false, double width = 160}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isHeader ? FontWeight.bold : (isHighlighted ? FontWeight.w600 : FontWeight.normal),
          color: isHeader ? AppColors.textSecondary : (isHighlighted ? AppColors.primary : AppColors.textPrimary),
        ),
      ),
    );
  }
}
