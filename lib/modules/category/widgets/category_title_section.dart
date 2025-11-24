import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/category/providers/categories_provider.dart';
import 'package:provider/provider.dart';


class CategoryTitleSection extends StatelessWidget {
  const CategoryTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoriesProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        "Browse Categories",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
