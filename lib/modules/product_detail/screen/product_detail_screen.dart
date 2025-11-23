import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../cart/provider/cart_provider.dart';
import '../provider/product_detail_provider.dart';
import '../widgets/product_detail_body.dart';
import '../widgets/product_detail_bottom_bar.dart';
import 'package:flutter_ecom/layout/top_nav_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ Load product details after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductDetailProvider>(context, listen: false)
          .loadProductDetail(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductDetailProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TopNavBar(),
      body: _buildBody(provider),
      bottomNavigationBar: provider.product == null
          ? null
          : ProductDetailBottomBar(
        product: provider.product!,
        // ✅ REMOVED: cart parameter (it's already available via Provider)
        // ✅ REMOVED: quantity parameter (should be managed internally)
        // ✅ REMOVED: onQuantityChange (should be managed internally)
      ),
    );
  }

  Widget _buildBody(ProductDetailProvider provider) {
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              "Error loading product\n${provider.error}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                provider.loadProductDetail(widget.productId);
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (provider.product == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Product not found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ProductDetailBody(product: provider.product!);
  }
}