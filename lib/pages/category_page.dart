import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testpro26/main.dart';
import 'package:testpro26/providers/product_provider.dart';
import 'package:go_router/go_router.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;
  const CategoryPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final items = provider.products
        .where(
          (p) => p.category.toLowerCase().contains(categoryName.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? const Center(
              child: Text(
                'No items found in this category',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(
                      Icons.image,
                      size: 40,
                      color: AppColors.textHint,
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${product.brand} - \$${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () {
                        context.push('/product/${product.barcode}');
                      },
                    ),
                    onTap: () {
                      context.push('/product/${product.barcode}');
                    },
                  ),
                );
              },
            ),
    );
  }
}
