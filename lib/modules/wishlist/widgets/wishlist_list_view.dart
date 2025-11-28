import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/theme/app_colors.dart';


import 'wishlist_item_card.dart';

class WishlistListView extends StatelessWidget {
  const WishlistListView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WishlistProvider>();

    return Column(
      children: [
        // ================= LIST =================
        Expanded(
          child: RefreshIndicator(
            color: AppColorsPrimary.primary,
            onRefresh: () => provider.loadWishlist(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, i) =>
                  WishlistItemCard(item: provider.items[i]),
            ),
          ),
        ),
      ],
    );
  }
}
