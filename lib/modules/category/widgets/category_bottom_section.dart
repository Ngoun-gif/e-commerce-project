import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/category/providers/categories_provider.dart';
import 'package:provider/provider.dart';


class CategoryBottomSection extends StatelessWidget {
  const CategoryBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoriesProvider>();

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Text(
          provider.selectedId == null
              ? "Select a category"
              : "Selected Category ID: ${provider.selectedId}",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
