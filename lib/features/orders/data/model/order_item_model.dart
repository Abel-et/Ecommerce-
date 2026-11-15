import 'package:ecommerce/features/orders/domain/entity/order_items.dart';

class OrderItemModel extends OrderItems {
  const OrderItemModel({
    required super.id,
    required super.priceAtPurchase,
    required super.productId,
    required super.quantity,
  });

  factory OrderItemModel.fromDbMap(Map<String, dynamic> map) {
    return OrderItemModel(
      id: map['id'] as String,
      priceAtPurchase: (map['price_at_purchase'] as num).toDouble(),
      productId: map['product_id'] as String,
      quantity: (map['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toDbMap(String parentOrderId) {
    return {
      'id': id,
      'order_id': parentOrderId,
      'product_id': productId,
      'quantity': quantity,
      'price_at_purchase': priceAtPurchase,
    };
  }

  factory OrderItemModel.fromEntity(OrderItems entity) {
    return OrderItemModel(
      id: entity.id,
      priceAtPurchase: entity.priceAtPurchase,
      productId: entity.productId,
      quantity: entity.quantity,
    );
  }
}
