import 'package:flutter/material.dart';

class WishlistBottomSection extends StatelessWidget {
  const WishlistBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.center,
      child: const Text(
        "— End of wishlist —",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
