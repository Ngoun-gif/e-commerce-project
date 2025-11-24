import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';

class ProductFavoriteButton extends StatelessWidget {
  final int productId;

  const ProductFavoriteButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WishlistProvider>();
    final isFav = provider.isFavorite(productId);

    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () => provider.toggle(productId),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(
          isFav ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: isFav ? Colors.red : Colors.grey[600],
        ),
      ),
    );
  }
}
