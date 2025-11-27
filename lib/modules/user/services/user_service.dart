import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/api_config_auth.dart';
import '../models/user.dart';

class UserService {
  // TOKEN
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  // HANDLE RESPONSE
  static dynamic _handle(http.Response res, String action) {
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception("$action failed: ${res.statusCode} ${res.body}");
  }

  // ================================
  // GET CURRENT USER
  // ================================
  static Future<UserModel> getMe() async {
    final token = await _getToken();

    final res = await http.get(
      Uri.parse(ApiConfigAuth.me),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    final json = _handle(res, "Fetch user profile");
    return UserModel.fromJson(json);
  }

  // ================================
  // UPDATE USER PROFILE
  // ================================
  static Future<UserModel> updateProfile({
    required String firstname,
    required String lastname,
    required String phone,
  }) async {
    final token = await _getToken();

    final res = await http.put(
      Uri.parse("${ApiConfigAuth.apiBase}/users/profile"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
      }),
    );

    final json = _handle(res, "Update profile");
    return UserModel.fromJson(json);
  }

  // ================================
  // CHANGE PASSWORD
  // ================================
  static Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = await _getToken();

    final res = await http.put(
      Uri.parse("${ApiConfigAuth.apiBase}/users/password"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "currentPassword": oldPassword,
        "newPassword": newPassword,
      }),
    );

    _handle(res, "Change password");
    return true;
  }
}
