class CartItem {
  final int productId;
  int quantity;

  CartItem({required this.productId, this.quantity = 1});

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(productId: json['productId'], quantity: json['quantity']);
  }
}
