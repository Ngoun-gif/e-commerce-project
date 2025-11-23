import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_config_checkout.dart';
import '../../auth/services/auth_service.dart';
import '../model/checkout_response.dart';

class CheckoutService {

  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ===============================
  // CHECKOUT
  // ===============================
  static Future<CheckoutResponse> checkout(String method) async {
    final headers = await _headers();

    final res = await http.post(
      Uri.parse(ApiConfigOrder.checkout),
      headers: headers,
      body: jsonEncode({"paymentMethod": method}),
    );

    if (res.statusCode != 200) {
      throw Exception(_extractError(res.body, "Checkout failed"));
    }

    return CheckoutResponse.fromJson(jsonDecode(res.body));
  }

  // ===============================
  // GET MY ORDERS
  // ===============================
  static Future<List<CheckoutResponse>> getMyOrders() async {
    final headers = await _headers();

    final res = await http.get(
      Uri.parse(ApiConfigOrder.myOrders),
      headers: headers,
    );

    if (res.statusCode != 200) {
      throw Exception(_extractError(res.body, "Fetch orders failed"));
    }

    final list = jsonDecode(res.body) as List;
    return list.map((e) => CheckoutResponse.fromJson(e)).toList();
  }

  // ===============================
  // ERROR PARSER
  // ===============================
  static String _extractError(String body, String fallback) {
    try {
      final json = jsonDecode(body);
      if (json is Map && json.containsKey("message")) {
        return json["message"];
      }
    } catch (_) {}
    return fallback;
  }
}
