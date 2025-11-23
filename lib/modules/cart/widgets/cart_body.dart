// lib/modules/cart/widgets/cart_body.dart

import 'package:flutter/material.dart';
import '../provider/cart_provider.dart';
import 'cart_item_tile.dart';

class CartBody extends StatelessWidget {
  final CartProvider provider;

  const CartBody({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    // CART LOADING (first load)
    if (provider.isCartLoading && provider.cart == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // ERROR UI
    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    // EMPTY CART
    if (provider.isEmpty) {
      return const Center(
        child: Text(
          "Your cart is empty",
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    final items = provider.cart!.items;

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];

        return CartItemTile(
          item: item,
          isMutating: provider.isMutating,
          onIncrease: () => provider.increase(item.id),
          onDecrease: () => provider.decrease(item.id),
          onRemove: () => provider.remove(item.id),
        );
      },
    );
  }
}
