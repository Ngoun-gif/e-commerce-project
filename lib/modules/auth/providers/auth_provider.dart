import 'package:flutter/material.dart';
import 'package:flutter_ecom/config/api_config_auth.dart';

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

  // Add this method to notify other providers
  void notifyAuthStateChanged() {
    notifyListeners();
  }

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
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _start();
    try {
      // First, debug the API response to see the actual structure
      print("🔍 Debugging API response structure...");
      await AuthService.debugApiResponse(
        ApiConfigAuth.login,
        {"email": email, "password": password},
      );

      final req = LoginRequest(email: email, password: password);
      final AuthResponse res = await AuthService.login(req);
      _accessToken = res.accessToken;

      print("✅ AuthProvider.login() - Login successful, token: ${_accessToken != null ? 'Received' : 'NULL'}");

      // ALWAYS use UserService.getMe() to ensure consistent UserModel
      try {
        _user = await UserService.getMe();
        print("✅ AuthProvider.login() - User data loaded from /users/me");
        _error = null;
      } catch (e) {
        print("⚠️ AuthProvider.login() - UserService error: $e");
        _user = null;
        _error = "Login successful but failed to load user profile";
      }
    } catch (e) {
      print("❌ AuthProvider.login() - Error: $e");
      _error = e.toString();

      // Provide user-friendly error messages
      if (e.toString().contains("Invalid email or password")) {
        _error = "Invalid email or password";
      } else if (e.toString().contains("Network error")) {
        _error = "Network error - please check your connection";
      } else if (e.toString().contains("Access token is missing")) {
        _error = "Login failed - server response incomplete";
      } else if (e.toString().contains("timeout")) {
        _error = "Request timeout - please try again";
      } else if (e.toString().contains("FormatException")) {
        _error = "Invalid server response";
      } else if (e.toString().contains("Null") && e.toString().contains("int")) {
        _error = "Server response format error - missing user data";
      }

      _accessToken = null;
      _user = null;
    }
    _finish();
    notifyListeners();
  }

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

      // ALWAYS use UserService.getMe() to ensure consistent UserModel
      try {
        _user = await UserService.getMe();
        print("✅ AuthProvider.register() - User data loaded from /users/me");
      } catch (e) {
        print("⚠️ AuthProvider.register() - UserService error: $e");
        // If UserService fails, we'll still have the token but no user data
        _user = null;
      }
    } catch (e) {
      print("❌ AuthProvider.register() - Error: $e");
      _error = e.toString();

      if (e.toString().contains("email") || e.toString().contains("Email")) {
        _error = "Email already exists or is invalid";
      } else if (e.toString().contains("username") || e.toString().contains("Username")) {
        _error = "Username already exists";
      } else {
        _error = "Registration failed. Please try again.";
      }
    }
    _finish();
    notifyListeners();
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