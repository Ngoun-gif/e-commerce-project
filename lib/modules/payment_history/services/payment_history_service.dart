import 'dart:convert';
import 'package:flutter_ecom/modules/payment_history/models/payment_history_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ecom/modules/auth/services/auth_service.dart';

import '../../../config/api_config_payment.dart';

class PaymentHistoryService {
  static Future<Map<String, String>> _headers() async {
    try {
      final token = await AuthService.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      print("🔐 PaymentHistoryService._headers() - Token: ${token != null ? 'Available' : 'NULL'}");
      return headers;
    } catch (e) {
      print("❌ PaymentHistoryService._headers() error: $e");
      rethrow;
    }
  }

  // ==================== GET ALL PAYMENTS ====================
  static Future<List<PaymentHistoryModel>> getAllPayments() async {
    print("🔄 PaymentHistoryService.getAllPayments() started");
    try {
      final headers = await _headers();
      final url = ApiConfigPayment.allPayment; // Using the new endpoint

      print("🌐 PaymentHistoryService - GET from: $url");
      print("🔑 PaymentHistoryService - Headers: $headers");

      final res = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("📡 PaymentHistoryService - Response status: ${res.statusCode}");
      print("📦 PaymentHistoryService - Response body: ${res.body}");

      // Handle empty response body
      if (res.body.isEmpty) {
        print("ℹ️ PaymentHistoryService - Empty response body");
        return [];
      }

      if (res.statusCode == 404) {
        print("ℹ️ PaymentHistoryService - 404 - No payments found");
        return [];
      }

      if (res.statusCode != 200) {
        throw Exception("Fetch all payments error: ${res.body}");
      }

      final responseData = jsonDecode(res.body);
      print("📋 PaymentHistoryService - Parsed JSON type: ${responseData.runtimeType}");

      // Handle null response
      if (responseData == null) {
        print("ℹ️ PaymentHistoryService - Response data is null");
        return [];
      }

      if (responseData is List) {
        // Backend returns a list of payments
        final List<PaymentHistoryModel> payments = [];

        for (var json in responseData) {
          try {
            final Map<String, dynamic> safeJson = _convertToSafeMap(json);
            final payment = PaymentHistoryModel.fromJson(safeJson);
            payments.add(payment);
          } catch (e) {
            print("❌ PaymentHistoryService - Error parsing payment item: $e");
            print("📋 Problematic item: $json");
            // Continue with other items instead of failing completely
          }
        }

        print("✅ PaymentHistoryService - Success! Found ${payments.length} payments");
        return payments;
      } else {
        print("❌ PaymentHistoryService - Unexpected response format: $responseData");
        return [];
      }
    } catch (e) {
      print("❌ PaymentHistoryService.getAllPayments() - Error: $e");
      print("📋 Error type: ${e.runtimeType}");
      rethrow;
    }
  }

  // ==================== GET SINGLE PAYMENT (if needed) ====================
  static Future<PaymentHistoryModel?> getLastPayment() async {
    print("🔄 PaymentHistoryService.getLastPayment() started");
    try {
      final headers = await _headers();
      final url = ApiConfigPayment.lastPayment;

      final res = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("📡 PaymentHistoryService.getLastPayment() - Response status: ${res.statusCode}");

      if (res.statusCode == 404) {
        print("ℹ️ PaymentHistoryService.getLastPayment() - 404 - No payment found");
        return null;
      }

      if (res.statusCode != 200) {
        throw Exception("Fetch last payment error: ${res.body}");
      }

      final responseData = jsonDecode(res.body);
      final safeJson = _convertToSafeMap(responseData);
      final payment = PaymentHistoryModel.fromJson(safeJson);

      print("✅ PaymentHistoryService.getLastPayment() - Success! Payment ID: ${payment.paymentId}");
      return payment;
    } catch (e) {
      print("❌ PaymentHistoryService.getLastPayment() - Error: $e");
      return null;
    }
  }

  // ==================== HELPER METHOD TO CONVERT MAP TYPES ====================
  static Map<String, dynamic> _convertToSafeMap(dynamic json) {
    if (json is Map<String, dynamic>) {
      return json;
    } else if (json is Map) {
      final Map<String, dynamic> safeMap = {};
      json.forEach((key, value) {
        safeMap[key.toString()] = value;
      });
      return safeMap;
    } else {
      throw Exception("Invalid JSON format: expected Map, got ${json.runtimeType}");
    }
  }

  // ==================== DEBUG API RESPONSE ====================
  static Future<void> debugApiResponse() async {
    try {
      final headers = await _headers();
      final url = ApiConfigPayment.allPayment; // Using the new endpoint

      print("🐛 DEBUG API RESPONSE - ALL PAYMENTS");
      print("🌐 URL: $url");
      print("🔑 Headers: $headers");

      final res = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("📡 Status: ${res.statusCode}");
      print("📦 Raw Body: '${res.body}'");
      print("📦 Body Length: ${res.body.length}");
      print("📦 Body Is Empty: ${res.body.isEmpty}");

      if (res.body.isNotEmpty) {
        try {
          final parsed = jsonDecode(res.body);
          print("📋 Parsed Type: ${parsed.runtimeType}");
          print("📋 Number of Payments: ${parsed is List ? parsed.length : 'N/A'}");
          print("📋 First Item: ${parsed is List && parsed.isNotEmpty ? parsed[0] : 'No items'}");
        } catch (e) {
          print("❌ JSON Parse Error: $e");
        }
      }
    } catch (e) {
      print("❌ Debug API Error: $e");
    }
  }
}