import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/models/product_model.dart';
import 'package:testpro26/providers/product_provider.dart';

class ComparePage extends StatelessWidget {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final selectedProducts = provider.comparisonList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Product Comparison'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: selectedProducts.isEmpty
                  ? _buildEmptyState()
                  : _buildComparisonTable(selectedProducts, provider),
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
          Icon(Icons.add_chart_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No products to compare', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Text('Scan barcodes to add products (up to 4)', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(List<Product> selectedProducts, ProductProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowHeight: 120,
          dataRowMinHeight: 60,
          dataRowMaxHeight: 80,
          columns: [
            const DataColumn(label: Text('Features', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
            ...selectedProducts.map((p) => DataColumn(
              label: Container(
                width: 120,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.image_outlined, color: AppColors.textHint),
                        ),
                        GestureDetector(
                          onTap: () => provider.removeFromComparison(p.id),
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )),
          ],
          rows: [
            _buildDataRow('Brand', selectedProducts, (p) => p.brand, isBold: true),
            _buildDataRow('Category', selectedProducts, (p) => p.category),
            _buildDataRow('Voltage', selectedProducts, (p) => p.voltage),
            _buildDataRow('Material', selectedProducts, (p) => p.material),
            _buildDataRow('Type/Features', selectedProducts, (p) => p.type),
            _buildDataRow('Warranty', selectedProducts, (p) => p.warranty, color: Colors.green[50]),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String title, List<Product> products, String Function(Product p) getValue, {bool isBold = false, Color? color}) {
    return DataRow(
      color: color != null ? WidgetStateProperty.all(color) : null,
      cells: [
        DataCell(Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
        ...products.map((p) {
          final val = getValue(p);
          return DataCell(
            Container(
              width: 120,
              alignment: Alignment.center,
              child: Text(
                val,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold ? AppColors.primary : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }),
      ],
    );
  }
}
