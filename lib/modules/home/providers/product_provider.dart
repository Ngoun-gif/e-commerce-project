import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  bool loading = true;

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    loading = true;
    notifyListeners();

    try {
      products = await ProductService.fetchProducts();
    } catch (e) {
      print("Error loading products: $e");
    }

    loading = false;
    notifyListeners();
  }
}
