import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/category/providers/categories_provider.dart';
import 'package:provider/provider.dart';


class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoriesProvider>();

    /// STATE 1: Loading placeholder (skeleton-like)
    if (provider.loading) {
      return SizedBox(
        height: 90,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, __) => Container(
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    /// STATE 2: Error UI
    if (provider.error != null) {
      return SizedBox(
        height: 90,
        child: Center(
          child: Text(
            provider.error!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    /// STATE 3: Empty UI
    if (provider.categories.isEmpty) {
      return const SizedBox(
        height: 90,
        child: Center(
          child: Text("No categories"),
        ),
      );
    }

    /// STATE 4: Normal UI
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: provider.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = provider.categories[index];
          final isSelected = provider.selectedId == cat.id;

          return GestureDetector(
            onTap: () => provider.selectCategory(cat.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? Colors.blue.shade50
                    : Colors.grey.shade200.withOpacity(.4),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 1.6,
                ),
              ),
              child: Center(
                child: Text(
                  cat.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isSelected ? Colors.blue : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
