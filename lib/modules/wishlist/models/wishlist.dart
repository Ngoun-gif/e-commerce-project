class WishlistModel {
  final int productId;
  final String title;
  final String image;
  final double price;

  WishlistModel({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      productId: json['productId'],
      title: json['title'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
