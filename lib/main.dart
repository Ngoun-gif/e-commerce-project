import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/checkout/provider/checkout_provider.dart';
import 'package:flutter_ecom/modules/payment/provider/payment_provider.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

import 'routers/app_routes.dart';
import 'modules/auth/providers/auth_provider.dart';

import 'modules/home/providers/product_provider.dart';
import 'modules/product_detail/provider/product_detail_provider.dart';
import 'modules/cart/provider/cart_provider.dart';
import 'modules/category/providers/categories_provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()..loadCategories()),
        ChangeNotifierProvider(create: (_) => ProductProvider()..loadProducts()),
        ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()), // <-- ADD THIS
        ChangeNotifierProvider(create: (_) => WishlistProvider()), // <-- ADD THIS

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
