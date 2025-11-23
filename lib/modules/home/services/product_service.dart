import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/api_config.dart';
import '../models/product.dart';

class ProductService {
  static Future<List<ProductModel>> fetchProducts() async {
    final url = Uri.parse(ApiConfig.products);

    print("🔵 FETCH PRODUCTS → $url");

    try {
      final response = await http.get(url);

      print("🟢 STATUS: ${response.statusCode}");
      print("🟡 RAW BODY:");
      print(response.body);
      print("----------------------------------------------------");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        print("🟠 DECODED JSON:");
        print(data);

        final products = data.map((p) {
          print("🧩 PRODUCT ITEM: $p");

          // Debug the image
          print("🖼️ RAW IMAGE FIELD: ${p['image']}");

          final fixedImage = ApiConfig.fixImage(p['image']);
          print("🖼️ FIXED IMAGE: $fixedImage");

          return ProductModel.fromJson(p);
        }).toList();

        print("✅ PRODUCTS LOADED: ${products.length}");

        return products;
      } else {
        print("❌ FAILED: ${response.statusCode}");
        throw Exception("Failed to load products");
      }
    } catch (e, stack) {
      print("🔥 EXCEPTION:");
      print(e);
      print(stack);
      rethrow;
    }
  }



}
