import 'cart_item.dart';

class CartModel {
  final int cartId;
  final double totalPrice;
  final List<CartItemModel> items;

  CartModel({
    required this.cartId,
    required this.totalPrice,
    required this.items,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List? ?? [])
        .map((e) => CartItemModel.fromJson(e))
        .toList();

    return CartModel(
      cartId: json['cartId'] ?? 0,
      totalPrice: (json['totalPrice'] as num? ?? 0).toDouble(),
      items: list,
    );
  }

  bool get isEmpty => items.isEmpty;
}
