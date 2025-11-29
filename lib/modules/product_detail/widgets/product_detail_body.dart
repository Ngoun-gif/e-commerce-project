import 'package:flutter/material.dart';
import '../../home/models/product.dart';

class ProductDetailBody extends StatelessWidget {
  final ProductModel product;

  const ProductDetailBody({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // IMAGE HEADER
        SliverAppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          expandedHeight: 300,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Hero(
              tag: product.id,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Image.network(
                    product.image,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 80),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
        ,

        // DETAIL CARD
        SliverToBoxAdapter(
          child: _detailCard(context),
        ),
      ],
    );
  }

  Widget _detailCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _category(),
          const SizedBox(height: 16),
          _title(),
          const SizedBox(height: 16),
          _priceStockRow(),
          const SizedBox(height: 24),
          _description(),
          const SizedBox(height: 30),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _category() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFF0D47A1).withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      product.category.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF0D47A1),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _title() => Text(
    product.title,
    style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.3,
    ),
  );

  Widget _priceStockRow() => Row(
    children: [
      // PRICE
      Text(
        "\$${product.price.toStringAsFixed(2)}",
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0D47A1),
        ),
      ),
      const Spacer(),
      // STOCK
      Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: product.outOfStock
              ? Colors.red.withOpacity(0.1)
              : Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              product.outOfStock
                  ? Icons.cancel_outlined
                  : Icons.check_circle_outline,
              size: 16,
              color: product.outOfStock ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 6),
            Text(
              product.outOfStock
                  ? "Out of Stock"
                  : "${product.stockQuantity} in Stock",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: product.outOfStock ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _description() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Description",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        product.description,
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.grey,
        ),
      ),
    ],
  );

  Widget _extraInfo() => Column(
    children: [
      _infoRow(Icons.local_shipping_outlined, "Free Shipping",
          "Delivery in 2-3 days"),
      const SizedBox(height: 16),
      _infoRow(Icons.assignment_return_outlined, "Easy Returns",
          "30 days return"),
    ],
  );

  Widget _infoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF0D47A1), size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
