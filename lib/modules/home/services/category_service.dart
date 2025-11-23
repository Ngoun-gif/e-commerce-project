import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../models/Category.dart';

class CategoryService {
  static Future<List<CategoryModel>> fetchCategories() async {
    final url = Uri.parse(ApiConfig.categories);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((c) => CategoryModel.fromJson(c)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }
}
