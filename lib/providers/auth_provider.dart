import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _currentUserEmail;
  
  String? get currentUserEmail => _currentUserEmail;

  static const String adminEmail = "admin@pro26.com";

  bool get isAdmin => _currentUserEmail == adminEmail;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserEmail = prefs.getString('user_email');
    notifyListeners();
  }

  Future<void> login(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    _currentUserEmail = email;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('access_token');
    _currentUserEmail = null;
    notifyListeners();
  }
}
