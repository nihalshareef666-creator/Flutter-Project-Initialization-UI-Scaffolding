import 'package:flutter/material.dart';
import 'package:testpro26/models/product_model.dart';
import 'package:testpro26/services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // API State
  bool _isLoading = false;
  String? _error;
  List<Product> _allProducts = [];
  final List<Product> _comparisonList = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Product> get products => _allProducts;
  List<Product> get comparisonList => _comparisonList;

  // -------------------------------
  // PRODUCT FETCHING
  // -------------------------------

  /// Fetch all products from API
  Future<void> fetchProducts() async {
    _setLoading(true);
    _clearError();

    try {
      final bikes = await _apiService.fetchAllProducts();
      _allProducts = bikes;
      notifyListeners();
    } catch (e) {
      _setError('Server error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Get specific product by barcode from API or Cache
  Future<Product?> fetchProductByBarcode(String barcode) async {
    // 1. Check local state (cache)
    try {
      final cached = _allProducts.firstWhere((p) => p.barcode == barcode);
      return cached;
    } catch (_) {
      // 2. Not in state, fetch from API
      _setLoading(true);
      _clearError();

      try {
        final product = await _apiService.fetchProductByBarcode(barcode);
        
        if (product != null) {
          // Store in state if not exists
          if (!_allProducts.any((p) => p.barcode == barcode)) {
             _allProducts.add(product);
          }
          return product;
        } else {
          _setError('Product not found');
          return null;
        }
      } catch (e) {
        _setError('Server error: ${e.toString()}');
        return null;
      } finally {
        _setLoading(false);
      }
    }
  }

  /// Search Products using Backend API
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return _allProducts;
    
    _setLoading(true);
    try {
      final results = await _apiService.searchProducts(query);
      return results;
    } catch (e) {
      _setError('Search failed: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  /// Add Product to Backend
  Future<bool> addProduct(Product product) async {
    _setLoading(true);
    _clearError();
    try {
      final newProduct = await _apiService.addProduct(product);
      _allProducts.add(newProduct);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add product: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProduct(Product product) async {
    _setLoading(true);
    _clearError();
    try {
      final updatedProduct = await _apiService.updateProduct(product);
      final index = _allProducts.indexWhere((p) => p.barcode == product.barcode);
      if (index != -1) {
        _allProducts[index] = updatedProduct;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to update product: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteProduct(String barcode) async {
    _setLoading(true);
    _clearError();
    try {
      final success = await _apiService.deleteProduct(barcode);
      if (success) {
        _allProducts.removeWhere((p) => p.barcode == barcode);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to delete product: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // -------------------------------
  // COMPARISON LOGIC
  // -------------------------------

  /// Get Comparison Data from AI or POST /compare
  Future<String?> getAiProductComparison() async {
    if (_comparisonList.isEmpty) return 'No products selected for comparison.';

    _setLoading(true);
    _clearError();

    try {
      final barcodes = _comparisonList.map((p) => p.barcode).toList();
      final response = await _apiService.fetchComparisonData(barcodes);
      
      // Assume backend returns { "recommendation": "..." } or "data"
      return response['recommendation']?.toString() ?? response['data']?.toString() ?? 'Comparison completed.';
    } catch (e) {
      _setError('Comparison Error: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  bool addToComparison(Product product) {
    if (_comparisonList.length >= 4) return false;
    
    if (!_comparisonList.any((p) => p.barcode == product.barcode)) {
      _comparisonList.add(product);
      notifyListeners();
    }
    return true;
  }

  void removeFromComparison(String barcode) {
    _comparisonList.removeWhere((p) => p.barcode == barcode);
    notifyListeners();
  }

  void clearComparison() {
    _comparisonList.clear();
    notifyListeners();
  }

  // -------------------------------
  // HELPERS
  // -------------------------------

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
