

import 'package:ecommerce/core/database/app_database.dart';
import 'package:ecommerce/features/orders/data/data_source/local/local_data_source.dart';
import 'package:ecommerce/features/orders/data/model/order_model.dart';

class OrderLocalDataSourceImpl implements OrderLocalDataSource{
  final AppDatabase appDatabase; 
  OrderLocalDataSourceImpl({
    required this.appDatabase
  });

  @override
  Future<void> createOrder(OrderModel order) async {
    await appDatabase.createOrder(order);
  }

  @override
  Future<List<OrderModel>> getAllOrders(String userId) async {
    final allOrder = await appDatabase.getAllOrders(userId);

    return allOrder;
  }
}