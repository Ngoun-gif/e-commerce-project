// category_by_product_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/category/models/product_by_category_model.dart';
import 'package:flutter_ecom/modules/category/services/category_by_product_service.dart';

class CategoryByProductProvider extends ChangeNotifier {
  List<ProductByCategoryModel> _allProducts = [];
  List<ProductByCategoryModel> _filteredProducts = [];
  bool _loading = true;
  String? _error;
  int? _selectedCategoryId;
  bool _initialLoaded = false;

  final CategoryByProductService _service = CategoryByProductService();

  // Getters
  List<ProductByCategoryModel> get products {
    return _selectedCategoryId == null ? _allProducts : _filteredProducts;
  }

  List<ProductByCategoryModel> get allProducts => _allProducts;
  bool get loading => _loading;
  String? get error => _error;
  int? get selectedCategoryId => _selectedCategoryId;
  bool get initialLoaded => _initialLoaded;
  int get productsCount => products.length;
  bool get isFiltered => _selectedCategoryId != null;


  /// Load all products
  Future<void> loadAllProducts() async {
    if (_initialLoaded && _allProducts.isNotEmpty) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _allProducts = await _service.fetchAllProducts();
      _filteredProducts = _allProducts;
      _initialLoaded = true;

      print("✅ ALL PRODUCTS LOADED: ${_allProducts.length}");
    } catch (e) {
      _error = e.toString();
      print("❌ Error loading all products: $e");
    }

    _loading = false;
    notifyListeners();
  }

  /// Filter products by category using API
  Future<void> filterProductsByCategory(int? categoryId) async {
    _selectedCategoryId = categoryId;

    if (categoryId == null) {
      _filteredProducts = _allProducts;
      print("🔄 Showing all products: ${_allProducts.length}");
      notifyListeners();
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      print("🔄 Filtering products by category: $categoryId");
      _filteredProducts = await _service.fetchProductsByCategory(categoryId);
      print("✅ API Filtered products: ${_filteredProducts.length}");

    } catch (e) {
      _error = e.toString();
      print("❌ Error filtering products by API: $e");

      // Since we can't filter by categoryId locally (API returns category name, not ID)
      // Just show empty or all products as fallback
      _filteredProducts = [];
      print("🔄 No local fallback available (category names don't match IDs)");
    }

    _loading = false;
    notifyListeners();
  }

  /// Clear filter
  void clearFilter() {
    _selectedCategoryId = null;
    _filteredProducts = _allProducts;
    notifyListeners();
    print("🔄 Cleared filter, showing all ${_allProducts.length} products");
  }

  /// Get product by ID
  ProductByCategoryModel? getProductById(int id) {
    try {
      return _allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search products
  List<ProductByCategoryModel> searchProducts(String query) {
    if (query.isEmpty) return products;

    final lowercaseQuery = query.toLowerCase();
    return products.where((product) {
      return product.title.toLowerCase().contains(lowercaseQuery) ||
          product.description.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Refresh data
  Future<void> reload() async {
    _initialLoaded = false;
    _selectedCategoryId = null;
    _filteredProducts = [];
    await loadAllProducts();
  }

  /// Get in-stock products
  List<ProductByCategoryModel> get inStockProducts {
    return products.where((product) => !product.outOfStock).toList();
  }

  /// Get out-of-stock products
  List<ProductByCategoryModel> get outOfStockProducts {
    return products.where((product) => product.outOfStock).toList();
  }
}