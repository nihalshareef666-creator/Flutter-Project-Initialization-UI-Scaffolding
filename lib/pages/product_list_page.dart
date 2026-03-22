import 'package:flutter/material.dart';
import 'package:testpro26/main.dart';
import 'package:go_router/go_router.dart';

class ProductListPage extends StatefulWidget {
  final String category;
  const ProductListPage({super.key, this.category = 'All Products'});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': '1 Pole 16A MCB Schneider',
      'brand': 'Schneider',
      'spec': 'Rating: 16A, Poles: 1P, Type: C',
    },
    {
      'id': 2,
      'name': '25L Water Heater Havells',
      'brand': 'Havells',
      'spec': '25L, 5 Star BEE, Glasslined',
    },
    {
      'id': 3,
      'name': 'Modular Switch 6A Legrand',
      'brand': 'Legrand',
      'spec': '6A, 1 Way, Child Safe',
    },
    {
      'id': 4,
      'name': 'LED Ceiling Light 18W Philips',
      'brand': 'Philips',
      'spec': '18W, Neutral White, 6500K',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── App Bar with SafeArea ───────────────────────────
          Container(
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'E&P Retail',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Icon(Icons.search, color: Colors.white, size: 22),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Breadcrumb
                    Row(
                      children: [
                        Text(
                          'Home / ',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.7), fontSize: 12),
                        ),
                        Text(
                          widget.category,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Category title + count ────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.category,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${products.length} items',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ── Product grid ─────────────────────────────────
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.72,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) =>
                  _ProductCard(products[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  const _ProductCard(this.product);

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _compareChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            height: 110,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F4F8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: const Center(
              child: Icon(Icons.electrical_services,
                  size: 48, color: Color(0xFFBBCCDD)),
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product['name'] as String,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.product['spec'] as String,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 9.5,
                    height: 1.4,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/product-details/890123456789');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      minimumSize: const Size(0, 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('View Details',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ),
                // Add to Compare
                Row(
                  children: [
                    Checkbox(
                      value: _compareChecked,
                      onChanged: (v) => setState(() => _compareChecked = v ?? false),
                      activeColor: AppColors.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    const Text(
                      'Add to Compare',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
