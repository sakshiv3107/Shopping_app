class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final int size;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.size,
    this.quantity = 1,
  });
}
