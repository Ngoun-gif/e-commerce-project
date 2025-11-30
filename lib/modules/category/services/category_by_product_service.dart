// category_by_product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_by_category_model.dart';
import 'package:flutter_ecom/config/api_config_category_by_product.dart'; // Your config

class CategoryByProductService {

  // Use your ApiConfig
  Future<List<ProductByCategoryModel>> fetchProductsByCategory(int categoryId) async {
    try {
      final url = ApiConfig.productsByCategory(categoryId);
      print('🌐 Fetching from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print('📦 Received ${jsonList.length} products for category $categoryId');

        // Safe parsing with error handling
        final List<ProductByCategoryModel> products = [];

        for (var jsonItem in jsonList) {
          try {
            if (jsonItem is Map<String, dynamic>) {
              final product = ProductByCategoryModel.fromJson(jsonItem);
              products.add(product);
            }
          } catch (e) {
            print('❌ Error parsing product item: $e');
            print('📄 Problematic item: $jsonItem');
            continue;
          }
        }

        print('✅ Successfully parsed ${products.length} products');
        return products;
      } else {
        throw Exception('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Network error fetching products by category: $e');
      rethrow;
    }
  }

  // If you need to fetch all products (for your provider)
  Future<List<ProductByCategoryModel>> fetchAllProducts() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.products),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => ProductByCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load all products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching all products: $e');
      rethrow;
    }
  }
}