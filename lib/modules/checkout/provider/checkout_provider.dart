import 'package:flutter/material.dart';
import '../model/checkout_response.dart';
import '../services/checkout_service.dart';

class OrderProvider extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  CheckoutResponse? _lastOrder;
  List<CheckoutResponse> _orders = [];

  bool get loading => _loading;
  String? get error => _error;
  CheckoutResponse? get lastOrder => _lastOrder;
  List<CheckoutResponse> get orders => _orders;

  void _start() {
    _loading = true;
    _error = null;
    notifyListeners();
  }

  void _finish() {
    _loading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ============================
  // CHECKOUT
  // ============================
  Future<void> checkout(String paymentMethod) async {
    _start();
    try {
      final res = await CheckoutService.checkout(paymentMethod);
      _lastOrder = res;

      // add new checkout to history
      _orders.insert(0, res);

    } catch (e) {
      _error = e.toString();
    }
    _finish();
  }

  // ============================
  // LOAD MY ORDERS
  // ============================
  Future<void> loadMyOrders() async {
    _start();
    try {
      _orders = await CheckoutService.getMyOrders();
    } catch (e) {
      _error = e.toString();
    }
    _finish();
  }
}
