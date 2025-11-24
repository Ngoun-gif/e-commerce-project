import 'package:flutter/material.dart';
import 'package:flutter_ecom/config/api_config_wishlist.dart';
import 'package:provider/provider.dart';

import '../models/wishlist.dart';
import '../providers/wishlist_provider.dart';

import '../../../routers/app_routes.dart';

class WishlistCard extends StatelessWidget {
  final WishlistModel item;
  const WishlistCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WishlistProvider>();

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetail,
          arguments: item.productId,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // ========================= IMAGE =========================
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                ApiConfigWishlist.fixImage(item.image),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 28),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // ========================= TITLE / PRICE =========================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "\$${item.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ========================= REMOVE BUTTON =========================
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => provider.remove(item.productId),
            ),
          ],
        ),
      ),
    );
  }
}
