class WishlistItem {
  final int? id;
  final int productId;
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  WishlistItem({
    this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  WishlistItem copyWith({
    int? id,
    int? productId,
    String? name,
    double? price,
    String? imageUrl,
    String? category,
  }) {
    return WishlistItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'category': category,
  };

  static WishlistItem fromJson(Map<String, dynamic> json) => WishlistItem(
    id: json['id'] as int?,
    productId: json['productId'] as int,
    name: json['name'] as String,
    price: json['price'] as double,
    imageUrl: json['imageUrl'] as String,
    category: json['category'] as String,
  );
}
