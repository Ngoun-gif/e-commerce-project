import 'package:flutter/material.dart';
import '../services/wishlist_service.dart';
import '../models/wishlist.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistService _service = WishlistService();

  bool _loading = false;
  bool get loading => _loading;

  List<WishlistModel> _items = [];
  List<WishlistModel> get items => _items;

  String? _error;
  String? get error => _error;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  // =============================
  // Authentication Methods
  // =============================

  /// Set authentication status and handle wishlist accordingly
  void setAuthenticated(bool authenticated, {bool notify = true}) {
    if (_isAuthenticated != authenticated) {
      _isAuthenticated = authenticated;
      if (!authenticated) {
        _clearWishlist(notify: false);
      }
      if (notify) {
        notifyListeners();
      }
    }
  }

  /// Clear wishlist data (used when logging out)
  void clearWishlist() {
    _clearWishlist();
  }

  void _clearWishlist({bool notify = true}) {
    _items = [];
    _error = null;
    _loading = false;
    if (notify) {
      notifyListeners();
    }
  }

  // =============================
  // Load wishlist with Auth Check
  // =============================
  Future<void> loadWishlist() async {
    // Don't load if not authenticated
    if (!_isAuthenticated) {
      _clearWishlist(notify: false);
      return;
    }

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedItems = await _service.fetchWishlist();
      _items = fetchedItems;
    } catch (e) {
      _error = "Failed to load wishlist";
      _items = []; // Clear items on error
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  bool isFavorite(int id) {
    if (!_isAuthenticated) return false;
    return _items.any((e) => e.productId == id);
  }

  // =============================
  // Toggle with Auth Check
  // =============================
  Future<void> toggle(
      int productId, {
        String? title,
        String? image,
        double? price,
      }) async {
    // Don't allow modifications if not authenticated
    if (!_isAuthenticated) {
      _error = "Please login to add items to wishlist";
      notifyListeners();
      return;
    }

    final exists = isFavorite(productId);

    // Optimistic UI update
    if (exists) {
      _items.removeWhere((e) => e.productId == productId);
    } else {
      _items.add(WishlistModel(
        productId: productId,
        title: title ?? "",
        image: image ?? "",
        price: price ?? 0,
      ));
    }
    notifyListeners();

    // Backend sync
    try {
      if (exists) {
        await _service.removeWishlist(productId);
      } else {
        await _service.addWishlist(productId);
      }
      // Reload to ensure sync with server
      await loadWishlist();
    } catch (e) {
      // Rollback on error
      await loadWishlist();
      _error = "Failed to update wishlist";
      notifyListeners();
    }
  }

  // =============================
  // Remove with Auth Check
  // =============================
  Future<void> remove(int id) async {
    // Don't allow modifications if not authenticated
    if (!_isAuthenticated) {
      _error = "Please login to modify wishlist";
      notifyListeners();
      return;
    }

    // Optimistic UI update
    _items.removeWhere((e) => e.productId == id);
    notifyListeners();

    try {
      await _service.removeWishlist(id);
      // Reload to ensure sync with server
      await loadWishlist();
    } catch (e) {
      // Rollback on error
      await loadWishlist();
      _error = "Failed to remove item from wishlist";
      notifyListeners();
    }
  }

  // =============================
  // Error Handling
  // =============================
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // =============================
  // Check if wishlist is empty (including auth state)
  // =============================
  bool get isEmpty {
    return !_isAuthenticated || _items.isEmpty;
  }

  // =============================
  // Get wishlist count (returns 0 if not authenticated)
  // =============================
  int get itemCount {
    return _isAuthenticated ? _items.length : 0;
  }
}