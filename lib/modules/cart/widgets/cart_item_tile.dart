// lib/modules/cart/widgets/cart_item_tile.dart

import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final bool isMutating;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.isMutating,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Temporary placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                "#${item.productId}",
                style: const TextStyle(fontSize: 12),
              ),
            ),

            const SizedBox(width: 12),

            // PRODUCT INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product ID: ${item.productId}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Price \$${item.price.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 13),
                  ),

                  Text(
                    "Total \$${item.total.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (item.outOfStock)
                    Text(
                      "Out of stock!",
                      style: TextStyle(color: theme.colorScheme.error),
                    ),

                  const SizedBox(height: 10),

                  // QUANTITY + REMOVE
                  Row(
                    children: [
                      // DECREASE
                      IconButton(
                        icon: isMutating
                            ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                            : const Icon(Icons.remove_circle_outline),
                        onPressed: isMutating ? null : onDecrease,
                      ),

                      Text(
                        "${item.quantity}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),

                      // INCREASE
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: isMutating ? null : onIncrease,
                      ),

                      const Spacer(),

                      // REMOVE
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: theme.colorScheme.error,
                        onPressed: isMutating ? null : onRemove,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
