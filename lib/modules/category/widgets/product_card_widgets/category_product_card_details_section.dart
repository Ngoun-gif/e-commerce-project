import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/home/models/product.dart';

class CategoryProductCardDetailsSection extends StatelessWidget {
  final ProductModel product;

  const CategoryProductCardDetailsSection({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategory(),
          const SizedBox(height: 4),
          Expanded(child: _buildTitle()), // 👈 fit inside flex
        ],
      ),
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        product.category.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0D47A1),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      product.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: Colors.black87,
      ),
    );
  }
}
