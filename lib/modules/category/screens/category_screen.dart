import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/category/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/category_body_section.dart';
import '../widgets/category_title_section.dart';
import '../widgets/category_bottom_section.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<CategoriesProvider>().loadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: Column(
        children: const [
          CategoryTitleSection(),
          Expanded(child: CategoryBodySection()),
          CategoryBottomSection(),
        ],
      ),
    );
  }
}
