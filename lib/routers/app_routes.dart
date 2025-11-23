import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/payment/screens/payment_screen.dart';
import 'package:flutter_ecom/modules/payment/screens/success_payment_screen.dart';


import '../modules/splash/screens/splash_screen.dart';
import '../layout/bottom_bar_layout.dart';
import '../modules/auth/screens/login_screen.dart';
import '../modules/auth/screens/register_screen.dart';
import '../modules/product_detail/screen/product_detail_screen.dart';
import '../modules/cart/screens/cart_screen.dart';
import '../modules/checkout/screens/checkout_screen.dart';


class AppRoutes {
  static const String splash = "/splash";
  static const String main = "/main";
  static const String login = "/login";
  static const String register = "/register";
  static const String productDetail = "/product-detail";
  static const String cart = "/cart";
  static const String checkout = "/checkout";
  static const String payment = "/payment";
  static const String successPayment = "/payment-success";

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    main: (_) => const BottomBarLayout(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    cart: (_) => const CartScreen(),
    checkout: (_) => const CheckoutScreen(),


    productDetail: (context) {
      final id = ModalRoute.of(context)!.settings.arguments as int;
      return ProductDetailScreen(productId: id);
    },
    payment: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      final int orderId = args['orderId'];
      final String method = args['method'];
      return PaymentScreen(orderId: orderId, method: method);
    },
    successPayment: (_) => const SuccessPaymentScreen(),




  };
}
