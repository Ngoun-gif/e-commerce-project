// lib/modules/cart/services/cart_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/api_config_cart.dart';
import '../models/cart.dart';

class CartService {
  // -------------------------------------------------------------
  // TOKEN FETCH (FIXED) — Matches AuthService key: "accessToken"
  // -------------------------------------------------------------
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken'); // ✔ FIXED
  }

  // -------------------------------------------------------------
  // Handle API Response
  // -------------------------------------------------------------
  static Future<CartModel> _handle(http.Response res, String action) {
    if (res.statusCode != 200) {
      throw Exception("$action failed: ${res.statusCode} ${res.body}");
    }
    return Future.value(
      CartModel.fromJson(jsonDecode(res.body)),
    );
  }

  // -------------------------------------------------------------
  // GET CART
  // -------------------------------------------------------------
  static Future<CartModel> getCart() async {
    final token = await _getToken();
    final res = await http.get(
      Uri.parse(ApiConfigCart.getCart),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    return _handle(res, "Get cart");
  }

  // -------------------------------------------------------------
  // ADD TO CART
  // -------------------------------------------------------------
  static Future<CartModel> addToCart(int productId, int qty) async {
    final token = await _getToken();

    final res = await http.post(
      Uri.parse(ApiConfigCart.add),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "productId": productId,
        "quantity": qty,
      }),
    );
    return _handle(res, "Add to cart");
  }

  // -------------------------------------------------------------
  // UPDATE CART ITEM
  // -------------------------------------------------------------
  static Future<CartModel> updateItem(int cartItemId, int qty) async {
    final token = await _getToken();
    final res = await http.put(
      Uri.parse(ApiConfigCart.update),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "cartItemId": cartItemId,
        "quantity": qty,
      }),
    );
    return _handle(res, "Update item");
  }

  // -------------------------------------------------------------
  // INCREASE CART ITEM
  // -------------------------------------------------------------
  static Future<CartModel> increase(int itemId) async {
    final token = await _getToken();

    final res = await http.put(
      Uri.parse(ApiConfigCart.increase(itemId)),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    return _handle(res, "Increase item");
  }

  // -------------------------------------------------------------
  // DECREASE CART ITEM
  // -------------------------------------------------------------
  static Future<CartModel> decrease(int itemId) async {
    final token = await _getToken();
    final res = await http.put(
      Uri.parse(ApiConfigCart.decrease(itemId)),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    return _handle(res, "Decrease item");
  }

  // -------------------------------------------------------------
  // REMOVE ITEM
  // -------------------------------------------------------------
  static Future<CartModel> remove(int itemId) async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse(ApiConfigCart.remove(itemId)),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    return _handle(res, "Remove item");
  }

  // -------------------------------------------------------------
  // CLEAR CART
  // -------------------------------------------------------------
  static Future<CartModel> clear() async {
    final token = await _getToken();
    final res = await http.delete(
      Uri.parse(ApiConfigCart.clear),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) "Authorization": "Bearer $token",
      },
    );
    return _handle(res, "Clear cart");
  }
}
