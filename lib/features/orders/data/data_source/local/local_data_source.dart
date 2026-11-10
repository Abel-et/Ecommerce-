

import 'package:ecommerce/features/orders/data/model/order_model.dart';

abstract class OrderLocalDataSource {
  Future<void> createOrder(OrderModel order);
  Future<List<OrderModel>?> getAllOrders();
}