import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Dynamically resolve base URL based on platform as per the integration guide
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000'; // Browser connects to localhost
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000'; 
    } else {
      return 'http://localhost:3000'; // Default for iOS Simulator
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);
        await prefs.setString('user_email', email);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
