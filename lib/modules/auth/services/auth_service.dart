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
    final response = await http.post(
      Uri.parse(ApiConfigAuth.login),
      headers: _jsonHeaders(),
      body: jsonEncode(request.toJson()),
    );

    if (_success(response.statusCode)) {
      final auth = AuthResponse.fromJson(jsonDecode(response.body));
      await _saveTokens(auth);
      return auth;
    }

    throw Exception("Login failed: ${response.body}");
  }

  // ============================================================
  // REGISTER
  // ============================================================
  static Future<AuthResponse> register(RegisterRequest req) async {
    final response = await http.post(
      Uri.parse(ApiConfigAuth.register),
      headers: _jsonHeaders(),
      body: jsonEncode(req.toJson()),
    );

    if (_success(response.statusCode)) {
      final auth = AuthResponse.fromJson(jsonDecode(response.body));
      await _saveTokens(auth);
      return auth;
    }

    throw Exception("Register failed: ${response.body}");
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
  }

  // ============================================================
  // PUBLIC — used by UserService + CartService
  // ============================================================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  // OPTIONAL: private helper
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  // ============================================================
  // CLEAR STORAGE (LOGOUT)
  // ============================================================
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ============================================================
  // HELPERS
  // ============================================================
  static Map<String, String> _jsonHeaders() =>
      {"Content-Type": "application/json"};

  static bool _success(int? code) =>
      code != null && code >= 200 && code < 300;
}
