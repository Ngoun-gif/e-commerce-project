import 'package:flutter/material.dart';

import '../modules/splash/screens/splash_screen.dart';
import '../layout/bottom_bar_layout.dart';
import '../modules/auth/screens/login_screen.dart';
import '../modules/auth/screens/register_screen.dart';
import '../modules/product_detail/screen/product_detail_screen.dart';
import '../modules/cart/screens/cart_screen.dart';

class AppRoutes {
  static const String splash = "/splash";
  static const String main = "/main";
  static const String login = "/login";
  static const String register = "/register";
  static const String productDetail = "/product-detail";
  static const String cart = "/cart";

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    main: (_) => const BottomBarLayout(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    cart: (_) => const CartScreen(),
    productDetail: (context) {
      final id = ModalRoute.of(context)!.settings.arguments as int;
      return ProductDetailScreen(productId: id);
    },
  };
}
