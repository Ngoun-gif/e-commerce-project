import 'package:flutter/material.dart';
import 'package:flutter_ecom/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';
import 'wishlist_item_card.dart';

class WishlistListView extends StatelessWidget {
  const WishlistListView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WishlistProvider>();

    return RefreshIndicator(
      onRefresh: () => provider.loadWishlist(),
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: provider.items.length,
        itemBuilder: (context, index) {
          return WishlistItemCard(item: provider.items[index]);
        },
      ),
    );
  }
}