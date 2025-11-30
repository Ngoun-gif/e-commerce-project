import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/api_config_auth.dart';
import '../models/user.dart';

class UserService {
  // ==========================
  // TOKEN
  // ==========================
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken");
  }

  // ==========================
  // HANDLE RESPONSE
  // ==========================
  static dynamic _handle(http.Response res, String action) {
    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception("$action failed: ${res.statusCode} ${res.body}");
  }

  // ==========================
  // GET /users/me
  // ==========================
  static Future<UserModel> getMe() async {
    final token = await _getToken();

    final res = await http.get(
      Uri.parse(ApiConfigAuth.me),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    return UserModel.fromJson(_handle(res, "Fetch user profile"));
  }

  // ==========================
  // PUT /users/{id}
  // ==========================
  static Future<UserModel> updateProfile({
    required int id,
    required String firstname,
    required String lastname,
    required String phone,
  }) async {
    final token = await _getToken();

    final res = await http.put(
      Uri.parse("${ApiConfigAuth.apiBase}/users/$id"),
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

    return UserModel.fromJson(_handle(res, "Update profile"));
  }

  // ==========================
  // POST /users/{id}/image
  // ==========================
  static Future<UserModel> uploadImage({
    required int id,
    required String path,
  }) async {
    final token = await _getToken();

    final req = http.MultipartRequest(
      "POST",
      Uri.parse("${ApiConfigAuth.apiBase}/users/$id/image"),
    );

    req.headers["Authorization"] = "Bearer $token";

    req.files.add(await http.MultipartFile.fromPath("file", path));

    final res = await req.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(body));
    }

    throw Exception("Upload image failed: $body");
  }
}
