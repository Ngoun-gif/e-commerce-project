import 'package:flutter/material.dart';
import '../../home/models/product.dart';
import '../services/product_detail_service.dart';

class ProductDetailProvider extends ChangeNotifier {
  ProductModel? product;
  bool loading = false;
  String? error;

  // ============================
  // 🔥 Load product by ID
  // ============================
  Future<void> loadProductDetail(int id) async {
    loading = true;
    product = null;
    error = null;
    notifyListeners();

    try {
      product = await ProductDetailService.getProductById(id);
    } catch (e) {
      error = "Failed to load product: $e";
    }

    loading = false;
    notifyListeners();
  }

  // ============================
  // 🔁 Reload the same product
  // ============================
  Future<void> reload() async {
    if (product == null) return;
    await loadProductDetail(product!.id);
  }

  // ============================
  // 🧹 Clear state
  // ============================
  void clear() {
    product = null;
    loading = false;
    error = null;
    notifyListeners();
  }
}
