import 'package:flutter/material.dart';
import 'package:flutter_ecom/config/api_config_wishlist.dart';
import 'package:flutter_ecom/modules/wishlist/models/wishlist.dart';

class ProductImageWidget extends StatelessWidget {
  final WishlistModel item;
  final bool isSelected;

  const ProductImageWidget({
    super.key,
    required this.item,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = ApiConfigWishlist.fixImage(item.image);

    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,

                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
            // Favorite indicator
            const Positioned(
              top: 6,
              right: 6,
              child: FavoriteIndicatorWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteIndicatorWidget extends StatelessWidget {
  const FavoriteIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.shade100,
            Colors.red.shade200,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200.withOpacity(0.3), // Blue shadow
            blurRadius: 6,
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      child: Icon(
        Icons.favorite_rounded,
        color: Colors.red.shade600,
        size: 16,
      ),
    );
  }
}