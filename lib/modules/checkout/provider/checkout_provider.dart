import 'package:flutter/material.dart';
import '../model/checkout_response.dart';
import '../services/checkout_service.dart';

class OrderProvider extends ChangeNotifier {
  bool _loading = false;
  String? _error;
  OrderResponse? _lastOrder;
  List<OrderResponse> _orders = [];

  bool get loading => _loading;
  String? get error => _error;
  OrderResponse? get lastOrder => _lastOrder;
  List<OrderResponse> get orders => _orders;

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
      final res = await OrderService.checkout(paymentMethod);
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
      _orders = await OrderService.getMyOrders();
    } catch (e) {
      _error = e.toString();
    }
    _finish();
  }
}
