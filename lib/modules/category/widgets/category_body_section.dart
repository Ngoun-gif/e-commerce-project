import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/category/providers/categories_provider.dart';
import 'package:flutter_ecom/modules/category/widgets/category_icon_mapper.dart';
import 'package:provider/provider.dart';


class CategoryBodySection extends StatelessWidget {
  const CategoryBodySection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoriesProvider>();

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    final list = provider.categories;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,            // 2 columns
        childAspectRatio: 1,         // 1:1 square cards
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemBuilder: (_, index) {
        final cat = list[index];
        final isSelected = provider.selectedId == cat.id;
        final icon = CategoryUIConfig.iconFor(cat.name);
        final bgColor = CategoryUIConfig.bgColorFor(index);

        return GestureDetector(
          onTap: () => provider.selectCategory(cat.id),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor.withOpacity(isSelected ? 0.9 : 0.55),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  cat.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
