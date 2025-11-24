import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ecom/modules/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_ecom/modules/wishlist/widgets/wishlist_title_section.dart';
import 'package:flutter_ecom/modules/wishlist/widgets/wishlist_body_section.dart';
import 'package:flutter_ecom/modules/wishlist/widgets/wishlist_bottom_section.dart';
import 'package:flutter_ecom/modules/wishlist/widgets/wishlist_card_section.dart';
import 'package:flutter_ecom/modules/wishlist/widgets/wishlist_button_section.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WishlistProvider>().loadWishlist());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wishlist")),
      body: Column(
        children: const [
          WishlistTitleSection(),
          Expanded(child: WishlistBodySection()),
          WishlistBottomSection(),
          WishlistButtonSection(),

        ],
      ),
    );
  }
}
