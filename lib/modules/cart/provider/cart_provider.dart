// lib/modules/cart/provider/cart_provider.dart

import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  CartModel? _cart;

  bool _loadingCart = false;
  bool _mutating = false; // increase/decrease/add/update in progress

  String? _error;

  CartModel? get cart => _cart;
  bool get isCartLoading => _loadingCart;
  bool get isMutating => _mutating;

  String? get error => _error;

  bool get isEmpty => _cart == null || _cart!.items.isEmpty;

  int get badgeCount {
    if (_cart == null) return 0;
    return _cart!.items.fold(0, (sum, item) => sum + item.quantity);
  }

  // ────────────────────────────────────────────────
  // INTERNAL HELPERS
  // ────────────────────────────────────────────────
  void _setCartLoading(bool v) {
    _loadingCart = v;
    notifyListeners();
  }

  void _setMutating(bool v) {
    _mutating = v;
    notifyListeners();
  }

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ────────────────────────────────────────────────
  // LOAD CART
  // ────────────────────────────────────────────────
  Future<void> loadCart() async {
    _setCartLoading(true);
    try {
      _cart = await CartService.getCart();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setCartLoading(false);
    }
  }

  // ────────────────────────────────────────────────
  // MUTATIONS (ADD / UPDATE / INCREASE / DECREASE)
  // ────────────────────────────────────────────────
  Future<void> add(int productId, int qty) async {
    _setMutating(true);
    try {
      _cart = await CartService.addToCart(productId, qty);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setMutating(false);
    }
  }

  Future<void> update(int itemId, int qty) async {
    _setMutating(true);
    try {
      _cart = await CartService.updateItem(itemId, qty);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setMutating(false);
    }
  }

  Future<void> increase(int itemId) async {
    _setMutating(true);
    try {
      _cart = await CartService.increase(itemId);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setMutating(false);
    }
  }

  Future<void> decrease(int itemId) async {
    _setMutating(true);
    try {
      _cart = await CartService.decrease(itemId);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setMutating(false);
    }
  }

  Future<void> remove(int itemId) async {
    _setMutating(true);
    try {
      _cart = await CartService.remove(itemId);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setMutating(false);
    }
  }

  Future<void> clear() async {
    _setMutating(true);
    try {
      _cart = await CartService.clear();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setMutating(false);
    }
  }
}
