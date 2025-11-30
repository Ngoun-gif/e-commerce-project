import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/category/models/category.dart';
import 'package:flutter_ecom/modules/category/services/categories_service.dart';



class CategoriesProvider extends ChangeNotifier {
  final CategoriesService _service = CategoriesService();

  List<CategoryModel> _categories = [];
  bool _loading = false;
  String? _error;
  int? _selectedId;
  bool _initialLoaded = false;

  List<CategoryModel> get categories => _categories;
  bool get loading => _loading;
  String? get error => _error;
  int? get selectedId => _selectedId;
  bool get initialLoaded => _initialLoaded;

  Future<void> loadCategories() async {
    if (_initialLoaded && _categories.isNotEmpty) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _service.fetchCategories();
      _initialLoaded = true;

      if (_categories.isNotEmpty && _selectedId == null) {
        _selectedId = _categories.first.id;
      }

    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  void selectCategory(int id) {
    if (_selectedId == id) return;
    _selectedId = id;
    notifyListeners();
  }

  void clearSelection() {
    _selectedId = null;
    notifyListeners();
  }

  String getSelectedName() {
    if (_selectedId == null) return "";

    try {
      return _categories.firstWhere((c) => c.id == _selectedId).name;
    } catch (_) {
      return "";
    }
  }

  Future<void> reload() async {
    _initialLoaded = false;
    await loadCategories();
  }
}