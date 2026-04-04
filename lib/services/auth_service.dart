import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
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
