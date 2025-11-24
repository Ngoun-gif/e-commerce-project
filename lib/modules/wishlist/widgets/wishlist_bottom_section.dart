import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';

class WishlistButtonSection extends StatelessWidget {
  const WishlistButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WishlistProvider>();

    return Container(
      height: 60,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: provider.items.isEmpty
                  ? null
                  : provider.clearLocal,
              child: const Text("Clear All"),
            ),
          ),
        ],
      ),
    );
  }
}
