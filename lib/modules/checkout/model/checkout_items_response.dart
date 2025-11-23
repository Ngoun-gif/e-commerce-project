class OrderItemRes {
  final int productId;
  final String title;
  final int quantity;
  final double price;
  final double total;

  OrderItemRes({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory OrderItemRes.fromJson(Map<String, dynamic> json) {
    return OrderItemRes(
      productId: json["productId"],
      title: json["title"],
      quantity: json["quantity"],
      price: double.tryParse(json["price"].toString()) ?? 0,
      total: double.tryParse(json["total"].toString()) ?? 0,
    );
  }
}
