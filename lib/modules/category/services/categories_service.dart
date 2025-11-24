import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../models/category.dart';

class CategoriesService {
  Future<List<CategoryModel>> fetchCategories() async {
    final url = Uri.parse(ApiConfig.categories);

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      }

      throw Exception("Failed to load categories: ${res.statusCode}");
    } catch (e) {
      throw Exception("Fetch categories error → $e");
    }
  }
}
