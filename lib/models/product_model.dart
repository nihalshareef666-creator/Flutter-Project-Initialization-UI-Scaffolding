class Product {
  final String name;
  final String brand;
  final String category;
  final String barcode;
  final double price;
  final double rating;

  Product({
    required this.name,
    required this.brand,
    required this.category,
    required this.barcode,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? 'Unknown',
      brand: json['brand'] ?? 'Unknown',
      category: json['category'] ?? 'General',
      barcode: json['barcode'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'brand': brand,
      'category': category,
      'barcode': barcode,
      'price': price,
      'rating': rating,
    };
  }
}
