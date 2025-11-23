// lib/modules/payment/service/payment_service.dart

import 'dart:convert';
import 'package:flutter_ecom/modules/auth/services/auth_service.dart';
import 'package:flutter_ecom/modules/payment/model/payment.dart';
import 'package:http/http.dart' as http;

import '../../../config/api_config_payment.dart';


class PaymentService {

  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ==================== PAY ====================
  static Future<PaymentModel> pay(int orderId, String method) async {
    final headers = await _headers();

    final body = jsonEncode({
      "orderId": orderId,
      "paymentMethod": method,
    });

    final res = await http.post(
      Uri.parse(ApiConfigPayment.pay),
      headers: headers,
      body: body,
    );

    if (res.statusCode != 200) {
      throw Exception("Payment failed: ${res.body}");
    }

    return PaymentModel.fromJson(jsonDecode(res.body));
  }

  // ==================== LAST PAYMENT ====================
  static Future<PaymentModel?> getLastPayment() async {
    final headers = await _headers();

    final res = await http.get(
      Uri.parse(ApiConfigPayment.lastPayment),
      headers: headers,
    );

    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) {
      throw Exception("Fetch last payment error: ${res.body}");
    }

    return PaymentModel.fromJson(jsonDecode(res.body));
  }
}
