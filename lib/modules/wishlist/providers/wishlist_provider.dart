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

  bool _initialized = false;

  // =============================
  // Enhanced Authentication Sync
  // =============================

  /// Update authentication state and handle wishlist accordingly
  void updateAuthState(bool authenticated) {
    print("🔄 WishlistProvider.updateAuthState() - Authenticated: $authenticated");

    if (_isAuthenticated != authenticated || !_initialized) {
      _isAuthenticated = authenticated;
      _initialized = true;

      if (authenticated) {
        // User logged in - load wishlist
        print("🔃 WishlistProvider - Loading wishlist for authenticated user");
        loadWishlist();
      } else {
        // User logged out - clear wishlist
        print("🧹 WishlistProvider - Clearing wishlist for logged out user");
        _clearWishlist(notify: false);
      }
      notifyListeners();
    }
  }

  /// Clear wishlist data
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
      print("🚫 WishlistProvider.loadWishlist() - Not authenticated, skipping");
      _clearWishlist(notify: false);
      return;
    }

    print("📥 WishlistProvider.loadWishlist() - Fetching wishlist...");
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedItems = await _service.fetchWishlist();
      _items = fetchedItems;
      _error = null;
      print("✅ WishlistProvider.loadWishlist() - Loaded ${_items.length} items");
    } catch (e) {
      _error = "Failed to load wishlist: ${e.toString()}";
      _items = [];
      print("❌ WishlistProvider.loadWishlist() - Error: $e");
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
    print("🔄 WishlistProvider.toggle() - Product: $productId, Exists: $exists");

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
        print("🗑️ WishlistProvider.toggle() - Removed product $productId");
      } else {
        await _service.addWishlist(productId);
        print("❤️ WishlistProvider.toggle() - Added product $productId");
      }
      // Reload to ensure sync with server
      await loadWishlist();
    } catch (e) {
      // Rollback on error
      await loadWishlist();
      _error = "Failed to update wishlist: ${e.toString()}";
      notifyListeners();
    }
  }

  // =============================
  // Remove with Auth Check
  // =============================
  Future<void> remove(int id) async {
    if (!_isAuthenticated) {
      _error = "Please login to modify wishlist";
      notifyListeners();
      return;
    }

    print("🗑️ WishlistProvider.remove() - Removing product $id");
    _items.removeWhere((e) => e.productId == id);
    notifyListeners();

    try {
      await _service.removeWishlist(id);
      await loadWishlist();
    } catch (e) {
      await loadWishlist();
      _error = "Failed to remove item from wishlist: ${e.toString()}";
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  bool get isEmpty {
    return !_isAuthenticated || _items.isEmpty;
  }

  int get itemCount {
    return _isAuthenticated ? _items.length : 0;
  }
}