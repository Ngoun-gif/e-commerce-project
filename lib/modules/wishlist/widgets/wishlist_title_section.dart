import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';

class WishlistTitleSection extends StatelessWidget {
  const WishlistTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WishlistProvider>();

    if (provider.loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Loading wishlist..."),
      );
    }

    if (provider.error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          provider.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        "Favorites: ${provider.items.length}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
