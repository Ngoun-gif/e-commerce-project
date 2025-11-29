import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/home/models/product.dart';
import 'package:flutter_ecom/modules/wishlist/widgets/product_favorite_button.dart';
import 'product_image_with_loading.dart';

class ProductCardImageSection extends StatelessWidget {
  final ProductModel product;

  const ProductCardImageSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Product Image Container
        Container(
          height: 120,
          width: double.infinity,
          child: Center(
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ProductImageWithLoading(product: product),
              ),
            ),
          ),
        ),

        // Top Badges
        Positioned(
          top: 6,
          left: 6,
          right: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Stock Status Badge
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: product.outOfStock
                        ? Colors.red.withOpacity(0.1)
                        : const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    product.outOfStock ? "SOLD OUT" : "IN STOCK",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: product.outOfStock
                          ? Colors.red[700]
                          : Colors.green[700],
                    ),
                  ),
                ),
              ),

              // Favorite Button
              ProductFavoriteButton(productId: product.id),
            ],
          ),
        ),

        // Single Additional Badge
        if (!product.outOfStock)
          Positioned(
            bottom: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.95),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_shipping, size: 9, color: Colors.white),
                  SizedBox(width: 2),
                  Text(
                    "FREE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}