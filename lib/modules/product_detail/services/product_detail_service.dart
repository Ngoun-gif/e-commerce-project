import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_config.dart';
import '../../home/models/product.dart';

class ProductDetailService {
  static Future<ProductModel> getProductById(int id) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.apiBase}/products/$id"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Failed to load product detail: ${response.body}");
  }
}
