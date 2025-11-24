import 'package:flutter/material.dart';
import '../models/wishlist.dart';
import '../services/wishlist_service.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistService _service = WishlistService();

  bool _loading = false;
  bool get loading => _loading;

  bool _updating = false;
  bool get updating => _updating;

  List<WishlistModel> _items = [];
  List<WishlistModel> get items => _items;

  String? _error;
  String? get error => _error;

  // ====================================
  // Load Wishlist From Backend
  // ====================================
  Future<void> loadWishlist() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final list = await _service.fetchWishlist();
      _items = list;
    } catch (e) {
      _error = "❗ Error loading wishlist: $e";
    }

    _loading = false;
    notifyListeners();
  }

  // ====================================
  // Check item exist
  // ====================================
  bool isFavorite(int productId) {
    return _items.any((e) => e.productId == productId);
  }

  // ====================================
  // Toggle Favorite (UI first then backend)
  // ====================================
  Future<void> toggle(
      int productId, {
        String? title,
        String? image,
        double? price,
      }) async {
    final exists = isFavorite(productId);

    // 🔥 Optimistic UI (instant)
    if (exists) {
      _items.removeWhere((e) => e.productId == productId);
    } else {
      _items.add(
        WishlistModel(
          productId: productId,
          title: title ?? "",
          image: image ?? "",
          price: price ?? 0,
        ),
      );
    }
    notifyListeners();

    // 🔐 Sync backend
    try {
      if (exists) {
        await _service.removeWishlist(productId);
      } else {
        await _service.addWishlist(productId);
      }

      await loadWishlist(); // Full refresh (recommended)

    } catch (e) {
      debugPrint("WISHLIST_TOGGLE_ERROR: $e");
      await loadWishlist(); // rollback UI
    }
  }

  // ====================================
  // Remove item
  // ====================================
  Future<void> remove(int productId) async {
    // instant UI
    _items.removeWhere((e) => e.productId == productId);
    notifyListeners();

    try {
      await _service.removeWishlist(productId);
      await loadWishlist();
    } catch (e) {
      debugPrint("WISHLIST_REMOVE_ERROR: $e");
      await loadWishlist();
    }
  }

  // ====================================
  // Clear wishlist UI only
  // ====================================
  void clearLocal() {
    _items.clear();
    notifyListeners();
  }
}
