import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_ecom/modules/wishlist/widgets/wishlist_card_section.dart';

class WishlistBodySection extends StatelessWidget {
  const WishlistBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WishlistProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.items.isEmpty) {
      return const Center(
        child: Text(
          "No favorites yet ❤️",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: provider.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, i) => WishlistCard(item: provider.items[i]),
    );
  }
}
