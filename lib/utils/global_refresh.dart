import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/home/providers/product_provider.dart';
import 'package:flutter_ecom/modules/user/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../modules/cart/provider/cart_provider.dart';
import '../modules/wishlist/providers/wishlist_provider.dart';


class GlobalRefresh {
  static Future<void> refresh(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final wishlist = context.read<WishlistProvider>();
    final user = context.read<UserProvider>();
    final product = context.read<ProductProvider>();

    await Future.wait([
      user.loadUser(),       // /users/me
      cart.loadCart(),       // GET cart
      wishlist.loadWishlist(),// GET wishlist
      product.loadProducts() // GET products
    ]);
  }
}
