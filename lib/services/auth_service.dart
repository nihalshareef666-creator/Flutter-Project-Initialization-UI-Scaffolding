import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Dynamically resolve base URL based on platform
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000'; // Browser connects to localhost
    } else if (Platform.isAndroid) {
      // NestJS server is running on this computer (192.168.1.5).
      return 'http://192.168.1.5:3000'; 
    } else {
      return 'http://localhost:3000'; // Default for iOS Simulator
    }
  }

  Future<bool> login(String email, String password) async {
    // TODO: Connect to backend once /auth/login is implemented.
    // For now, simulating a successful login so you can get into the app!
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', 'temporary_mock_token');
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    // TODO: Connect to backend once /auth/register is implemented.
    // For now, simulating a successful registration!
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  Future<bool> forgotPassword(String email) async {
    // TODO: Connect to backend once /auth/forgot-password is implemented.
    // For now, simulating a successful request!
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
