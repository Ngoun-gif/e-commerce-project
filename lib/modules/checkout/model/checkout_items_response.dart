class CheckoutItemRes {
  final int productId;
  final String title;
  final int quantity;
  final double price;
  final double total;

  CheckoutItemRes({
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory CheckoutItemRes.fromJson(Map<String, dynamic> json) {
    return CheckoutItemRes(
      productId: json["productId"],
      title: json["title"],
      quantity: json["quantity"],
      price: double.tryParse(json["price"].toString()) ?? 0,
      total: double.tryParse(json["total"].toString()) ?? 0,
    );
  }
}
