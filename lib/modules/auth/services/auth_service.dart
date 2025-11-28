import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/api_config_auth.dart';
import '../models/auth_response.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../../user/models/user.dart';

class AuthService {
  // ============================================================
  // LOGIN
  // ============================================================
  static Future<AuthResponse> login(LoginRequest request) async {
    print("🔄 AuthService.login() - Starting login for: ${request.email}");

    try {
      final response = await http.post(
        Uri.parse(ApiConfigAuth.login),
        headers: _jsonHeaders(),
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 30));

      print("📡 AuthService.login() - Response status: ${response.statusCode}");
      print("📡 AuthService.login() - Response body: ${response.body}");

      if (_success(response.statusCode)) {
        final responseData = jsonDecode(response.body);

        // Debug the response structure
        print("🔍 AuthService.login() - Response keys: ${responseData.keys}");
        print("🔍 AuthService.login() - AccessToken present: ${responseData.containsKey('accessToken')}");
        print("🔍 AuthService.login() - User present: ${responseData.containsKey('user')}");

        final auth = AuthResponse.fromJson(responseData);

        // Validate critical fields
        if (auth.accessToken.isEmpty) {
          throw Exception("Access token is missing from response");
        }

        await _saveTokens(auth);
        print("✅ AuthService.login() - Login successful for: ${auth.user.email}");
        return auth;
      }

      // Handle specific error codes
      if (response.statusCode == 401) {
        throw Exception("Invalid email or password");
      } else if (response.statusCode == 400) {
        throw Exception("Bad request - check your input");
      } else if (response.statusCode == 500) {
        throw Exception("Server error - please try again later");
      } else {
        throw Exception("Login failed: ${response.statusCode} ${response.body}");
      }
    } on http.ClientException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on FormatException catch (e) {
      throw Exception("Invalid response format: $e");
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================
  static Future<AuthResponse> register(RegisterRequest req) async {
    print("🔄 AuthService.register() - Starting registration for: ${req.email}");

    try {
      final response = await http.post(
        Uri.parse(ApiConfigAuth.register),
        headers: _jsonHeaders(),
        body: jsonEncode(req.toJson()),
      ).timeout(const Duration(seconds: 30));

      print("📡 AuthService.register() - Response status: ${response.statusCode}");
      print("📡 AuthService.register() - Response body: ${response.body}");

      if (_success(response.statusCode)) {
        final responseData = jsonDecode(response.body);

        // Debug the response structure
        print("🔍 AuthService.register() - Response keys: ${responseData.keys}");

        final auth = AuthResponse.fromJson(responseData);

        // Validate critical fields
        if (auth.accessToken.isEmpty) {
          throw Exception("Access token is missing from response");
        }

        await _saveTokens(auth);
        print("✅ AuthService.register() - Registration successful for: ${auth.user.email}");
        return auth;
      }

      // Parse error message from response if available
      String errorMessage = "Registration failed";
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
      } catch (_) {
        errorMessage = "Registration failed: ${response.statusCode}";
      }

      throw Exception(errorMessage);
    } on http.ClientException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on FormatException catch (e) {
      throw Exception("Invalid response format: $e");
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  // ============================================================
  // SAVE TOKENS
  // ============================================================
  static Future<void> _saveTokens(AuthResponse auth) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken", auth.accessToken);
      await prefs.setString("refreshToken", auth.refreshToken);
      await prefs.setString("userEmail", auth.user.email);
      await prefs.setString(
        "userName",
        "${auth.user.firstname} ${auth.user.lastname}",
      );
      print("💾 AuthService._saveTokens() - Tokens saved for: ${auth.user.email}");
    } catch (e) {
      print("❌ AuthService._saveTokens() - Error saving tokens: $e");
      throw Exception("Failed to save login session");
    }
  }

  // ============================================================
  // PUBLIC — used by UserService + CartService
  // ============================================================
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("accessToken");
      print("🔐 AuthService.getToken() - Token: ${token != null ? 'Available' : 'NULL'}");
      return token;
    } catch (e) {
      print("❌ AuthService.getToken() - Error reading token: $e");
      return null;
    }
  }
  // In AuthService class
  static Future<void> debugApiResponse(String endpoint, Map<String, dynamic> body) async {
    try {
      print("====== DEBUG API RESPONSE ======");
      print("Endpoint: $endpoint");
      print("Request body: $body");

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("Status: ${response.statusCode}");
      print("Headers: ${response.headers}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Parsed JSON type: ${data.runtimeType}");
        print("All keys: ${data.keys}");

        if (data is Map) {
          data.forEach((key, value) {
            print("$key: $value (type: ${value.runtimeType})");
            if (value is Map) {
              print("  Subkeys: ${value.keys}");
            }
          });
        }
      }
      print("==================================");
    } catch (e) {
      print("Debug failed: $e");
    }
  }

  // ============================================================
  // CLEAR STORAGE (LOGOUT)
  // ============================================================
  static Future<void> clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print("🧹 AuthService.clearTokens() - All tokens cleared");
    } catch (e) {
      print("❌ AuthService.clearTokens() - Error clearing tokens: $e");
      throw Exception("Failed to logout properly");
    }
  }

  // ============================================================
  // DEBUG METHOD - Temporary to check API response structure
  // ============================================================
  static Future<void> debugLoginResponse(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfigAuth.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("====== DEBUG LOGIN RESPONSE ======");
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response type: ${data.runtimeType}");
        print("All keys: ${data.keys}");
        if (data is Map) {
          data.forEach((key, value) {
            print("$key: $value (type: ${value.runtimeType})");
          });
        }
      }
      print("==================================");
    } catch (e) {
      print("Debug failed: $e");
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================
  static Map<String, String> _jsonHeaders() =>
      {"Content-Type": "application/json"};

  static bool _success(int? code) =>
      code != null && code >= 200 && code < 300;
}