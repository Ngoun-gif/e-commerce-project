import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // GET (list)
  static Future<dynamic> get(String url) async {
    final res = await http.get(Uri.parse(url));
    return jsonDecode(res.body);
  }

  // GET with headers (JWT)
  static Future<dynamic> getAuth(String url, String token) async {
    final res = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(res.body);
  }

  // POST JSON
  static Future<dynamic> postJson(String url, Map data) async {
    final res = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  // POST JSON with JWT
  static Future<dynamic> postAuth(String url, Map data, String token) async {
    final res = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }
}
