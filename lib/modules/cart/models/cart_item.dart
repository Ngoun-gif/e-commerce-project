class CartItemModel {
  final int id;
  final int productId;
  final int quantity;
  final double price;
  final double total;
  final bool outOfStock;
  final int availableStock;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.total,
    required this.outOfStock,
    required this.availableStock,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num? ?? 0).toDouble(),
      total: (json['total'] as num? ?? 0).toDouble(),
      outOfStock: json['outOfStock'] ?? false,
      availableStock: json['availableStock'] ?? 0,
    );
  }
}
