// when a single product become order item 
class OrderItems {
  final String id; 
  final String productId;
  final int quantity;
  final double priceAtPurchase;

  const OrderItems({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.priceAtPurchase
  });

  double get totalRowPrice => quantity * priceAtPurchase;
}