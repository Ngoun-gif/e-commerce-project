import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_config_auth.dart';
import '../../auth/services/auth_service.dart';
import '../models/user.dart';

class UserService {
  static Future<UserModel> getMe() async {
    final token = await AuthService.getToken();  // ✔ FIXED — use public getter

    if (token == null) {
      throw Exception("No access token available");
    }

    final response = await http.get(
      Uri.parse(ApiConfigAuth.me),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Failed to fetch /users/me: ${response.body}");
  }
}
