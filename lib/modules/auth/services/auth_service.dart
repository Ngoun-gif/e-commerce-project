// lib/modules/auth/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/api_config_auth.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthService {

  // ============================================================
  // LOGIN
  // ============================================================
  static Future<AuthResponse> login(LoginRequest request) async {
    print("🔄 AuthService.login() - Starting login for: ${request.email}");

    final response = await http.post(
      Uri.parse(ApiConfigAuth.login),
      headers: _jsonHeaders(),
      body: jsonEncode(request.toJson()),
    );

    print("📡 AuthService.login() - Response status: ${response.statusCode}");

    if (_success(response.statusCode)) {
      final responseData = jsonDecode(response.body);
      final auth = AuthResponse.fromJson(responseData);
      await _saveTokens(auth);
      print("✅ AuthService.login() - Login successful for: ${auth.user.email}");
      return auth;
    }

    throw Exception("Login failed: ${response.statusCode} ${response.body}");
  }

  // ============================================================
  // REGISTER
  // ============================================================
  static Future<AuthResponse> register(RegisterRequest req) async {
    print("🔄 AuthService.register() - Starting registration for: ${req.email}");

    final response = await http.post(
      Uri.parse(ApiConfigAuth.register),
      headers: _jsonHeaders(),
      body: jsonEncode(req.toJson()),
    );

    print("📡 AuthService.register() - Response status: ${response.statusCode}");

    if (_success(response.statusCode)) {
      final responseData = jsonDecode(response.body);
      final auth = AuthResponse.fromJson(responseData);
      await _saveTokens(auth);
      print("✅ AuthService.register() - Registration successful for: ${auth.user.email}");
      return auth;
    }

    throw Exception("Register failed: ${response.statusCode} ${response.body}");
  }

  // ============================================================
  // SAVE TOKENS
  // ============================================================
  static Future<void> _saveTokens(AuthResponse auth) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", auth.accessToken);
    await prefs.setString("refreshToken", auth.refreshToken);
    await prefs.setString("userEmail", auth.user.email);
    await prefs.setString(
      "userName",
      "${auth.user.firstname} ${auth.user.lastname}",
    );
    print("💾 AuthService._saveTokens() - Tokens saved for: ${auth.user.email}");
  }

  // ============================================================
  // PUBLIC — used by UserService + CartService
  // ============================================================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    print("🔐 AuthService.getToken() - Token: ${token != null ? 'Available' : 'NULL'}");
    return token;
  }

  // ============================================================
  // CLEAR STORAGE (LOGOUT)
  // ============================================================
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("🧹 AuthService.clearTokens() - All tokens cleared");
  }

  // ============================================================
  // HELPERS
  // ============================================================
  static Map<String, String> _jsonHeaders() =>
      {"Content-Type": "application/json"};

  static bool _success(int? code) =>
      code != null && code >= 200 && code < 300;
}