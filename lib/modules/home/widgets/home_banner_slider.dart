import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  int _currentIndex = 0;

  final List<String> bannerImages = [
    'assets/Cover.png',
    'assets/AMT-Push.jpg',
    'assets/3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: bannerImages.map((imgPath) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imgPath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),

        const SizedBox(height: 8),

        // 🔵 Page Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bannerImages.asMap().entries.map((entry) {
            bool active = _currentIndex == entry.key;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: active ? 14 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: active ? Colors.blueAccent : Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
