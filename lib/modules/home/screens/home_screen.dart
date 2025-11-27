import 'package:flutter/material.dart';
import 'package:flutter_ecom/utils/global_refresh.dart';

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
    return RefreshIndicator(
      onRefresh: () async {
        await GlobalRefresh.refresh(context);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          HomeSearchBar(),
          SizedBox(height: 20),
          HomeBannerSlider(),
          SizedBox(height: 20),
          HomeSectionTitle(title: "Categories"),
          HomeCategories(),
          SizedBox(height: 20),
          HomeSectionTitle(title: "Popular Products"),
          HomePopularProducts(),
        ],
      ),
    );
  }
}

