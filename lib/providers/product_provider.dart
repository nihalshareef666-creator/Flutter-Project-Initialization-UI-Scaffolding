import 'package:flutter/material.dart';
import 'package:testpro26/models/product_model.dart';
import 'package:testpro26/models/user_model.dart';

class ProductProvider with ChangeNotifier {
  // Mock Data DB
  final List<Product> _products = [
    Product(
      id: 1,
      name: 'Havells Adonia R 25L',
      brand: 'Havells',
      category: 'Water Heater',
      barcode: '890123456789',
      addedBy: 'admin',
      addedByRole: UserRole.admin,
      shopName: 'TechPlumb',
      dateAdded: DateTime.now(),
      voltage: '2000W',
      material: 'Glasslined Steel',
      type: 'IoT Enabled, 5 Star',
      warranty: '2yr Tank',
      isAiRecommended: true,
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: 2,
      name: 'V-Guard Calisto 25L',
      brand: 'V-Guard',
      category: 'Water Heater',
      barcode: '890123456790',
      addedBy: 'admin',
      addedByRole: UserRole.admin,
      shopName: 'TechPlumb',
      dateAdded: DateTime.now(),
      voltage: '2000W',
      material: 'Classlined Steel',
      type: '4 Star BEE',
      warranty: '5yr Tank',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    Product(
      id: 3,
      name: 'Schneider MCB 16A',
      brand: 'Schneider',
      category: 'Electricals',
      barcode: '890123456791',
      addedBy: 'admin',
      addedByRole: UserRole.admin,
      shopName: 'TechPlumb',
      dateAdded: DateTime.now(),
      voltage: '16A',
      material: 'Polycarbonate',
      type: '1 Pole, Type C',
      warranty: '1yr',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    // Additional Mock items
    Product(
      id: 4,
      name: 'Anchor Roma Switch 6A',
      brand: 'Anchor',
      category: 'Switches',
      barcode: '123456789012',
      addedBy: 'staff',
      addedByRole: UserRole.staff,
      shopName: 'TechPlumb',
      dateAdded: DateTime.now(),
      voltage: '6A',
      material: 'Plastic',
      type: 'Modular',
      warranty: 'N/A',
      imageUrl: 'https://via.placeholder.com/150',
    )
  ];

  List<Product> get products => _products;

  // Comparison List State
  final List<Product> _comparisonList = [];
  List<Product> get comparisonList => _comparisonList;

  Product? getProductByBarcode(String barcode) {
    try {
      return _products.firstWhere((p) => p.barcode == barcode);
    } catch (_) {
      return null;
    }
  }

  bool addToComparison(Product product) {
    if (_comparisonList.length >= 4) {
      return false; // Limit up to 4
    }
    // Prevent duplicates
    if (!_comparisonList.any((p) => p.id == product.id)) {
      _comparisonList.add(product);
      notifyListeners();
    }
    return true;
  }

  void removeFromComparison(int productId) {
    _comparisonList.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
