import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/category_provider.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    if (provider.loading) {
      return SizedBox(
        height: 90,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            5,
                (_) => Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: provider.categories.map((cat) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                cat.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
