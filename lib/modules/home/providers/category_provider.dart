import 'package:flutter/material.dart';
import '../models/Category.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  bool loading = true;
  List<CategoryModel> categories = [];

  Future<void> loadCategories() async {
    loading = true;
    notifyListeners();

    categories = await CategoryService.fetchCategories();

    loading = false;
    notifyListeners();
  }
}
