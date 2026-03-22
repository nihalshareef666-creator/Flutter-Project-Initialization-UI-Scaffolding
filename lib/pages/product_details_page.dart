import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:testpro26/providers/product_provider.dart';
import 'package:testpro26/main.dart'; // AppColors

class ProductDetailsPage extends StatelessWidget {
  final String barcode;
  const ProductDetailsPage({super.key, required this.barcode});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final product = provider.getProductByBarcode(barcode);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: product == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Product not found for barcode:\n$barcode',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                      boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 10)],
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 80, color: AppColors.textHint),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text(product.brand, style: const TextStyle(fontSize: 18, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 24),
                  _buildSectionCard(
                    title: 'Specifications',
                    icon: Icons.list_alt,
                    children: [
                      _buildSpecRow('Voltage / Power', product.voltage),
                      _buildSpecRow('Material', product.material),
                      _buildSpecRow('Type / Features', product.type),
                      _buildSpecRow('Warranty', product.warranty),
                      _buildSpecRow('Category', product.category),
                      _buildSpecRow('Barcode', product.barcode),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final added = provider.addToComparison(product);
                        if (added) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to comparison!'), backgroundColor: AppColors.success),
                          );
                          // Navigate to Compare screen
                          context.push('/compare');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Comparison full (max 4 products).'), backgroundColor: AppColors.error),
                          );
                        }
                      },
                      icon: const Icon(Icons.compare_arrows),
                      label: const Text('Add to Compare'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
