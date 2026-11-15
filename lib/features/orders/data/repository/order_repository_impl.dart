

import 'package:ecommerce/features/orders/data/data_source/local/local_data_source.dart';
import 'package:ecommerce/features/orders/data/model/order_model.dart';
import 'package:ecommerce/features/orders/domain/entity/order_entity.dart';
import 'package:ecommerce/features/orders/domain/repository/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository{
  final OrderLocalDataSource localDataSource; 

  OrderRepositoryImpl({
    required this.localDataSource
  });


  @override
  Future<void> createOrder(OrderEntity order) async{
    try{
      final orderModle = OrderModel.fromEntity(order);

      await localDataSource.createOrder(orderModle);
    } catch(e) { 
      throw Exception('Failed to create order in database: $e');
    }

  }


  @override
  Future<List<OrderEntity>> getAllOrders(String userId) async{
    try{
      final List<OrderModel> orderModel = await localDataSource.getAllOrders(userId);
    return orderModel;
    }catch(e){
      throw Exception('Failed to fetch all order form database $e');
    }
    
  }
}