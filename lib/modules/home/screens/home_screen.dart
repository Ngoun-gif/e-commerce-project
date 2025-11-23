import 'package:flutter/material.dart';

// import your widgets
import '../widgets/home_search_bar.dart';
import '../widgets/home_banner_slider.dart';
import '../widgets/home_section_title.dart';
import '../widgets/home_categories.dart';
import '../widgets/home_popular_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [

        // 🔍 Search
        HomeSearchBar(),
        SizedBox(height: 20),

        // 🖼 Banner Slider
        HomeBannerSlider(),
        SizedBox(height: 20),

        // 🏷 Categories
        HomeSectionTitle(title: "Categories"),
        HomeCategories(),
        SizedBox(height: 20),

        // 🛍 Popular Products
        HomeSectionTitle(title: "Popular Products"),
        HomePopularProducts(),
      ],
    );
  }
}
