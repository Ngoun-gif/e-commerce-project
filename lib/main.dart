import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/checkout/provider/checkout_provider.dart';
import 'package:flutter_ecom/modules/payment/provider/payment_provider.dart';
import 'package:flutter_ecom/modules/payment_history/provider/payment_history_provider.dart';
import 'package:flutter_ecom/modules/user/providers/user_provider.dart';
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
        // Auth Provider
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider()..checkAuthStatus(),
        ),

        // Categories Provider
        ChangeNotifierProvider<CategoriesProvider>(
          create: (_) => CategoriesProvider()..loadCategories(),
        ),

        // Product Provider
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider()..loadProducts(),
        ),

        // User Provider
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider()..loadUser(),
        ),

        // Wishlist Provider with Auth dependency
        ChangeNotifierProxyProvider<AuthProvider, WishlistProvider>(
          create: (context) => WishlistProvider(),
          update: (context, authProvider, wishlistProvider) {
            wishlistProvider ??= WishlistProvider();
            // Sync auth state whenever AuthProvider changes
            wishlistProvider.updateAuthState(authProvider.isAuthenticated);
            return wishlistProvider;
          },
        ),

        // Cart Provider with Auth dependency
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (context) => CartProvider(),
          update: (context, authProvider, cartProvider) {
            cartProvider ??= CartProvider();
            // If you have auth sync in CartProvider, add it here
            return cartProvider;
          },
        ),

        // Other providers
        ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => PaymentHistoryProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}