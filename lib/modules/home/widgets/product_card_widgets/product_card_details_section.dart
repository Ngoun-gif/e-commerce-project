import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/home/models/product.dart';

class ProductCardDetailsSection extends StatelessWidget {
  final ProductModel product;

  const ProductCardDetailsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Section: Category, Title, Rating
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category
              _buildCategory(),
              const SizedBox(height: 6),

              // Product Title
              _buildProductTitle(),
              const SizedBox(height: 4),

              // Rating
              _buildRatingSection(),
            ],
          ),

          // Bottom Section: Price and Stock
          _buildPriceAndStockSection(),
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        product.category.toUpperCase(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: const Color(0xFF0D47A1),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildProductTitle() {
    return SizedBox(
      height: 36,
      child: Text(
        product.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.3,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        // Star Rating
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < 4 ? Icons.star : Icons.star_border,
              size: 16,
              color: Colors.amber,
            );
          }),
        ),
        const SizedBox(width: 3),

        // Rating Text
        Text(
          "4.8",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(width: 2),

        // Reviews Count
        Text(
          "(128)",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndStockSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Price Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Price
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 1),
                ],
              ),
            ),
            const SizedBox(width: 6),

          ],
        ),
      ],
    );
  }
}