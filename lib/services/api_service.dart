import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class ApiService {
  // Dynamically resolve base URL based on platform as per the integration guide
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000'; // Web or iOS Simulator (localhost)
    } else if (Platform.isAndroid) {
      // Android Emulator connects via 10.0.2.2
      return 'http://10.0.2.2:3000'; 
    } else {
      return 'http://localhost:3000'; // iOS Simulator or other
    }
  }

  // Get headers including Bearer token
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // -------------------------------
  // GENERIC REQUEST METHODS (With Auth)
  // -------------------------------

  Future<dynamic> _get(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('GET Request failed: $e');
    }
  }

  Future<dynamic> _post(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('POST Request failed: $e');
    }
  }

  Future<dynamic> _put(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('PUT Request failed: $e');
    }
  }

  Future<dynamic> _delete(String endpoint) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: headers,
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('DELETE Request failed: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      final errorSnippet = response.body.length > 100
          ? response.body.substring(0, 100)
          : response.body;

      throw Exception(
        'API Error (${response.statusCode}): $errorSnippet',
      );
    }
  }

  // -------------------------------
  //  PRODUCT APIs
  // -------------------------------

  /// GET /products → fetch all products
  Future<List<Product>> fetchAllProducts() async {
    try {
      final data = await _get('/products');
      final List list = data is List ? data : (data['data'] ?? []);
      return list.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  /// GET /products/:barcode → fetch single product
  Future<Product?> fetchProductByBarcode(String barcode) async {
    try {
      final data = await _get('/products/$barcode');
      
      // If backend wraps response { success, data }
      final Map<String, dynamic> productJson = data['data'] ?? data;
      
      if (productJson.isEmpty) return null;
      return Product.fromJson(productJson);
    } catch (e) {
      // Return null or throw depending on if 404 is expected
      return null;
    }
  }

  /// POST /products/compare → fetch comparison data
  /// Expects body: { "barcodes": ["111", "222"] }
  Future<Map<String, dynamic>> fetchComparisonData(List<String> barcodes) async {
    try {
      final data = await _post('/products/compare', {
        'barcodes': barcodes,
      });
      // Response expected: { "success": true, "data": [...], "recommendation": "..." }
      return data;
    } catch (e) {
      throw Exception('Comparison failed: $e');
    }
  }

  /// Search Products (if backend has search, otherwise filter frontend)
  /// GET /products/search?q=query
  Future<List<Product>> searchProducts(String query) async {
    try {
      final data = await _get('/products/search?q=$query');
      final List list = data is List ? data : (data['data'] ?? []);
      return list.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      // Fallback or rethrow
      return [];
    }
  }

  /// POST /products → add new product
  Future<Product> addProduct(Product product) async {
    try {
      final data = await _post('/products', product.toJson());
      return Product.fromJson(data['data'] ?? data);
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  /// PUT /products/:barcode → update product
  Future<Product> updateProduct(Product product) async {
    try {
      final data = await _put('/products/${product.barcode}', product.toJson());
      return Product.fromJson(data['data'] ?? data);
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  /// DELETE /products/:barcode → delete product
  Future<bool> deleteProduct(String barcode) async {
    try {
      final data = await _delete('/products/$barcode');
      // Assume backend returns { "success": true } or data
      final result = data is Map ? data['success'] == true : data != null;
      return result;
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}