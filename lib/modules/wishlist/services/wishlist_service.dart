import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_ecom/config/api_config_wishlist.dart';
import 'package:flutter_ecom/modules/auth/services/auth_service.dart';
import '../models/wishlist.dart';

class WishlistService {
  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // =========================
  // GET /wishlist
  // =========================
  Future<List<WishlistModel>> fetchWishlist() async {
    final url = Uri.parse(ApiConfigWishlist.wishlist);

    final res = await http.get(url, headers: await _headers());

    if (res.statusCode == 200) {
      final List body = jsonDecode(res.body);
      return body.map((e) => WishlistModel.fromJson(e)).toList();
    }

    throw Exception("Failed to fetch wishlist (${res.statusCode})");
  }

  // =========================
  // POST /wishlist/add/{productId}
  // =========================
  Future<bool> addWishlist(int productId) async {
    final url = Uri.parse(ApiConfigWishlist.addWishlist(productId));
    final res = await http.post(url, headers: await _headers());
    return res.statusCode == 200 || res.statusCode == 201;
  }

  // =========================
  // DELETE /wishlist/remove/{productId}
  // =========================
  Future<bool> removeWishlist(int productId) async {
    final url = Uri.parse(ApiConfigWishlist.removeWishlist(productId));
    final res = await http.delete(url, headers: await _headers());
    return res.statusCode == 200 || res.statusCode == 204;
  }
}
