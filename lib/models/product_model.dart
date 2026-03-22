import 'package:testpro26/models/user_model.dart';

class Product {
  final int id;
  final String name;
  final String brand;
  final String category;
  final String barcode;
  final String addedBy;
  final UserRole addedByRole;
  final String shopName;
  final DateTime dateAdded;

  // New specific fields for detail and comparison
  final String voltage;
  final String material;
  final String type;
  final String warranty;
  final String imageUrl;
  final bool isAiRecommended;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.barcode,
    required this.addedBy,
    required this.addedByRole,
    required this.shopName,
    required this.dateAdded,
    this.voltage = 'N/A',
    this.material = 'N/A',
    this.type = 'N/A',
    this.warranty = 'N/A',
    this.imageUrl = '',
    this.isAiRecommended = false,
  });
}
