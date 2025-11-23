// lib/modules/payment/provider/payment_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/payment/model/payment.dart';
import 'package:flutter_ecom/modules/payment/services/payment_service.dart';


class PaymentProvider extends ChangeNotifier {
  PaymentModel? lastPayment;
  bool loading = false;
  String? error;

  // ==================== PAY ====================
  Future<bool> pay(int orderId, String method) async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      final payment = await PaymentService.pay(orderId, method);

      lastPayment = payment;
      loading = false;
      notifyListeners();

      return true;
    } catch (e) {
      loading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ==================== LAST PAYMENT ====================
  Future<void> fetchLastPayment() async {
    try {
      loading = true;
      error = null;
      notifyListeners();

      final p = await PaymentService.getLastPayment();
      lastPayment = p;

      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      error = e.toString();
      notifyListeners();
    }
  }

  // ==================== RESET ====================
  void clear() {
    lastPayment = null;
    error = null;
    notifyListeners();
  }
}
