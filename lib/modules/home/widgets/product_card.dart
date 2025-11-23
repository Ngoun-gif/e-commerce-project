import 'package:flutter/material.dart';
import '../../../routers/app_routes.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetail,
          arguments: product.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section - Fixed height
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[100],
                      child: _ProductImageWithLoading(product: product),
                    ),
                  ),

                  // Stock Status Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: product.outOfStock
                            ? Colors.red.withOpacity(0.9)
                            : const Color(0xFF0D47A1).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.outOfStock ? "SOLD OUT" : "IN STOCK",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      color: const Color(0xFF0D47A1).withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Product Title - Fixed to prevent overflow
                  SizedBox(
                    height: 40, // Fixed height for title
                    child: Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        height: 1.3,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Price and Stock Row
                  Row(
                    children: [
                      // Price
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D47A1),
                        ),
                      ),

                      const Spacer(),

                      // Stock Quantity - FIXED: Removed the problematic text
                      if (!product.outOfStock && product.stockQuantity > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "${product.stockQuantity} left", // FIXED: Proper stock text
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Separate widget for image loading states
class _ProductImageWithLoading extends StatefulWidget {
  final ProductModel product;

  const _ProductImageWithLoading({required this.product});

  @override
  State<_ProductImageWithLoading> createState() => _ProductImageWithLoadingState();
}

class _ProductImageWithLoadingState extends State<_ProductImageWithLoading> {
  late final ImageProvider _imageProvider;

  @override
  void initState() {
    super.initState();
    _imageProvider = NetworkImage(widget.product.image);
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: _imageProvider,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _ImageErrorState(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _ImageLoadingState(loadingProgress: loadingProgress);
      },
    );
  }
}

// Image Loading State Widget
class _ImageLoadingState extends StatelessWidget {
  final ImageChunkEvent? loadingProgress;

  const _ImageLoadingState({this.loadingProgress});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded / loadingProgress!.expectedTotalBytes!
              : null,
          color: const Color(0xFF0D47A1),
          backgroundColor: Colors.grey[300],
        ),
      ),
    );
  }
}

// Image Error State Widget
class _ImageErrorState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey,
              size: 40,
            ),
            SizedBox(height: 4),
            Text(
              'No Image',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}