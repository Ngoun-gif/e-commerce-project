import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routers/app_routes.dart';
import 'modules/auth/providers/auth_provider.dart';
import 'modules/home/providers/category_provider.dart';
import 'modules/home/providers/product_provider.dart';
import 'modules/product_detail/provider/product_detail_provider.dart';
import 'modules/cart/provider/cart_provider.dart';

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
        ChangeNotifierProvider(create: (_) => CategoryProvider()..loadCategories()),
        ChangeNotifierProvider(create: (_) => ProductProvider()..loadProducts()),
        ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
