import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/home/models/product.dart';
import 'package:flutter_ecom/modules/home/widgets/product_card_widgets/product_card_details_section.dart';
import 'package:flutter_ecom/modules/home/widgets/product_card_widgets/product_card_image_section.dart'; // ADD THIS IMPORT
import '../../../../routers/app_routes.dart';

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
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductCardImageSection(product: product),
            Expanded(
              child: ProductCardDetailsSection(product: product),
            ),
          ],
        ),
      ),
    );
  }
}