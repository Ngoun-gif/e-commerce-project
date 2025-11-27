import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modules/cart/provider/cart_provider.dart';
import '../modules/wishlist/providers/wishlist_provider.dart';
import '../modules/home/providers/product_provider.dart';
import '../modules/user/providers/user_provider.dart';

class GlobalRefresh {
  static Future<void> refresh(BuildContext context) async {
    try {
      final futures = <Future>[];

      if (_has<CartProvider>(context)) {
        futures.add(context.read<CartProvider>().loadCart());
      }
      if (_has<WishlistProvider>(context)) {
        futures.add(context.read<WishlistProvider>().loadWishlist());
      }
      if (_has<UserProvider>(context)) {
        futures.add(context.read<UserProvider>().loadUser());
      }
      if (_has<ProductProvider>(context)) {
        futures.add(context.read<ProductProvider>().loadProducts());
      }

      await Future.wait(futures);
    } catch (e) {
      print("⚠️ GlobalRefresh Error: $e");
    }
  }

  static bool _has<T>(BuildContext context) {
    return context.read<T>() != null;
  }
}
