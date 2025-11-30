import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/category/models/product_by_category_model.dart';
import 'package:flutter_ecom/modules/category/widgets/category_app_bar.dart';
import 'package:flutter_ecom/modules/category/widgets/products_horizontal_list.dart';
import 'package:flutter_ecom/modules/category/widgets/section_header.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/modules/category/providers/category_by_product_provider.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryByProductProvider>().loadAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CategoryAppBar(),
      body: Consumer<CategoryByProductProvider>(
        builder: (context, productsProvider, child) {
          if (productsProvider.loading && !productsProvider.initialLoaded) {
            return _buildLoadingSections();
          }

          if (productsProvider.error != null) {
            return _buildErrorSection(productsProvider.error!);
          }

          return _buildCategoryProductsSections(productsProvider);
        },
      ),
    );
  }

  Widget _buildCategoryProductsSections(CategoryByProductProvider productsProvider) {
    final allProducts = productsProvider.allProducts;

    // Group products by category
    final Map<String, List<ProductByCategoryModel>> productsByCategory = {};

    for (final product in allProducts) {
      if (!productsByCategory.containsKey(product.category)) {
        productsByCategory[product.category] = [];
      }
      productsByCategory[product.category]!.add(product);
    }

    // Create sections for each category
    return ListView(
      padding: const EdgeInsets.all(16),
      children: productsByCategory.entries.map((entry) {
        final categoryName = entry.key;
        final categoryProducts = entry.value;

        return Column(
          children: [
            SectionHeader(
              title: _getDisplayName(categoryName),
              onSeeAll: () => _onSeeAllPressed(categoryName),
            ),
            const SizedBox(height: 10),
            ProductsHorizontalList(products: categoryProducts),
            const SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLoadingSections() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(title: "Loading...", onSeeAll: () {}),
        const SizedBox(height: 10),
        const ProductsHorizontalList(products: []),
        const SizedBox(height: 20),

        SectionHeader(title: "Loading...", onSeeAll: () {}),
        const SizedBox(height: 10),
        const ProductsHorizontalList(products: []),
        const SizedBox(height: 20),

        SectionHeader(title: "Loading...", onSeeAll: () {}),
        const SizedBox(height: 10),
        const ProductsHorizontalList(products: []),
      ],
    );
  }

  Widget _buildErrorSection(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to load products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<CategoryByProductProvider>().reload();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayName(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case "men's clothing":
        return "Men";
      case "women's clothing":
        return "Women";
      case "electronics":
        return "Electronics";
      case "jewelery":
        return "Jewelry";
      default:
        return categoryName;
    }
  }

  void _onSeeAllPressed(String categoryName) {
    debugPrint("Tapped on 'See All' for $categoryName");
    // Implement see all functionality
  }
}