// lib/modules/auth/providers/auth_provider.dart

import 'package:flutter/material.dart';

import '../../user/models/user.dart';
import '../../user/services/user_service.dart';
import '../services/auth_service.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/auth_response.dart';

class AuthProvider extends ChangeNotifier {

  UserModel? _user;
  String? _accessToken;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isAuthenticated => _accessToken != null;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> checkAuthStatus() async {
    _start();
    try {
      _accessToken = await AuthService.getToken();
      if (_accessToken != null) {
        _user = await UserService.getMe();
        print("✅ AuthProvider.checkAuthStatus() - User loaded: ${_user?.email}");
      } else {
        print("ℹ️ AuthProvider.checkAuthStatus() - No token found");
      }
    } catch (e) {
      print("❌ AuthProvider.checkAuthStatus() - Error: $e");
      _error = "Failed to load user profile";
      _accessToken = null;
      _user = null;
    }
    _finish();
  }

  Future<void> login(String email, String password) async {
    _start();
    try {
      final req = LoginRequest(email: email, password: password);
      final AuthResponse res = await AuthService.login(req);
      _accessToken = res.accessToken;

      print("✅ AuthProvider.login() - Login successful, token: ${_accessToken != null ? 'Received' : 'NULL'}");

      // Try to get fresh user data from /users/me
      try {
        _user = await UserService.getMe();
        print("✅ AuthProvider.login() - User data loaded from /users/me");
      } catch (e) {
        print("⚠️ AuthProvider.login() - UserService error: $e");
        print("🔄 AuthProvider.login() - Falling back to AuthResponse user data");
        _user = res.user; // Use the user from AuthResponse as fallback
      }
    } catch (e) {
      print("❌ AuthProvider.login() - Error: $e");
      _error = e.toString();
    }
    _finish();
  }

  // In your AuthProvider class, update the register method:

  Future<void> register(
      String firstname,
      String lastname,
      String username,
      String email,
      String phone,
      String password,
      ) async {
    _start();
    try {
      final req = RegisterRequest(
        email: email,
        password: password,
        username: username,
        firstname: firstname,
        lastname: lastname,
        phone: phone,
      );

      final AuthResponse res = await AuthService.register(req);
      _accessToken = res.accessToken;

      print("✅ AuthProvider.register() - Registration successful, token: ${_accessToken != null ? 'Received' : 'NULL'}");

      // Try to get fresh user data from /users/me
      try {
        _user = await UserService.getMe();
        print("✅ AuthProvider.register() - User data loaded from /users/me");
      } catch (e) {
        print("⚠️ AuthProvider.register() - UserService error: $e");
        print("🔄 AuthProvider.register() - Falling back to AuthResponse user data");
        _user = res.user;
      }
    } catch (e) {
      print("❌ AuthProvider.register() - Error: $e");
      _error = e.toString();

      // More specific error handling
      if (e.toString().contains("email") || e.toString().contains("Email")) {
        _error = "Email already exists or is invalid";
      } else if (e.toString().contains("username") || e.toString().contains("Username")) {
        _error = "Username already exists";
      } else {
        _error = "Registration failed. Please try again.";
      }
    }
    _finish();
  }

  Future<void> logout() async {
    print("🚪 AuthProvider.logout() - Logging out user");
    await AuthService.clearTokens();
    _user = null;
    _accessToken = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _start() {
    _loading = true;
    _error = null;
    notifyListeners();
  }

  void _finish() {
    _loading = false;
    notifyListeners();
  }
}