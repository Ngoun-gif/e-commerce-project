import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/categories_service.dart';

class CategoriesProvider extends ChangeNotifier {
  final CategoriesService _service = CategoriesService();

  bool _loading = false;
  bool get loading => _loading;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  String? _error;
  String? get error => _error;

  int? _selectedId;
  int? get selectedId => _selectedId;

  // ============================
  // LOAD DATA
  // ============================
  Future<void> loadCategories() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _service.fetchCategories();

      // OPTIONAL 👉 auto select the first category
      if (_categories.isNotEmpty && _selectedId == null) {
        _selectedId = _categories.first.id;
      }

    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  // ============================
  // HANDLE SELECT
  // ============================
  void selectCategory(int id) {
    _selectedId = id;
    notifyListeners();
  }

  // ============================
  // RESET SELECTION
  // ============================
  void clearSelection() {
    _selectedId = null;
    notifyListeners();
  }
}
