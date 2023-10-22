class CartItem {
  final String productId;
  final String productName;
  final double productPrice;
  final String productImageUrl;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImageUrl,
    required this.quantity,
  });
}
