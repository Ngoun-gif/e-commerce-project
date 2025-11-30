import 'dart:convert';
import 'package:flutter_ecom/modules/category/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ecom/config/api_config.dart'; // Fixed import

class CategoriesService {
  Future<List<CategoryModel>> fetchCategories() async {
    final url = Uri.parse(ApiConfig.categories);

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      }

      throw Exception("Failed to fetch categories: ${res.statusCode}");
    } catch (e) {
      rethrow;
    }
  }
}