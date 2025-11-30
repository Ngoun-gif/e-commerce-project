import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/category/widgets/product_card_widgets/category_product_card_details_section.dart';
import 'package:flutter_ecom/modules/category/widgets/product_card_widgets/category_product_card_image_section.dart';
import 'package:flutter_ecom/modules/home/models/product.dart';
import 'package:flutter_ecom/routers/app_routes.dart';

class CategoryProductCard extends StatelessWidget {
  final ProductModel product;

  const CategoryProductCard({
    super.key,
    required this.product,
    required bool isHorizontal,
  });

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
        height: 220, // 👈 fixed card height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 120, // 👈 fixed image height
              width: double.infinity,
              child: CategoryProductCardImageSection(product: product),
            ),
            Expanded(
              child: CategoryProductCardDetailsSection(product: product),
            ),
          ],
        ),
      ),
    );
  }
}
