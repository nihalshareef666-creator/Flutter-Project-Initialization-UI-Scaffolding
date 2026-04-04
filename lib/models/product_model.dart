class Product {
  final String name;
  final String brand;
  final String category;
  final String barcode;
  final String? imageUrl;
  final Map<String, String>? specifications;

  Product({
    required this.name,
    required this.brand,
    required this.category,
    required this.barcode,
    this.imageUrl,
    this.specifications,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? 'Unknown',
      brand: json['brand'] ?? 'Unknown',
      category: json['category'] ?? 'General',
      barcode: json['barcode'] ?? '',
      imageUrl: json['imageUrl'] as String?,
      specifications: json['specifications'] != null
          ? Map<String, dynamic>.from(json['specifications']).map(
              (key, value) => MapEntry(key, value.toString()),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'category': category,
      'barcode': barcode,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (specifications != null) 'specifications': specifications,
    };
  }
}
