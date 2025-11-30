import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/category/models/product_by_category_model.dart';
import 'package:flutter_ecom/modules/category/widgets/product_card_widgets/category_product_card.dart';
import 'package:flutter_ecom/modules/home/models/product.dart';

class ProductsHorizontalList extends StatelessWidget {
  final List<ProductByCategoryModel> products;

  const ProductsHorizontalList({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return _buildLoadingState();

    return SizedBox(
      height: 240, // 👈 give breathing room
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 160,
            child: CategoryProductCard(
              product: _createModel(product),
              isHorizontal: false,
            ),
          );
        },
      ),
    );
  }

  ProductModel _createModel(ProductByCategoryModel p) {
    return ProductModel(
      id: p.id,
      title: p.title,
      price: p.price,
      description: p.description,
      category: p.category,
      image: p.image,
      outOfStock: p.outOfStock,
      stockQuantity: p.stockQuantity,
    );
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 240,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
