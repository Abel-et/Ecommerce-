

import 'package:ecommerce/features/orders/domain/entity/order_entity.dart';

abstract class OrderRepository {

  Future<void> createOrder(OrderEntity order); 
  Future<List<OrderEntity>> getAllOrders(String userId);
}