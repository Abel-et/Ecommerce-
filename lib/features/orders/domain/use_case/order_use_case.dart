
import 'package:ecommerce/features/orders/domain/entity/order_entity.dart';
import 'package:ecommerce/features/orders/domain/repository/order_repository.dart';

class GetAllOrdersUseCase{
  final OrderRepository repository; 

  GetAllOrdersUseCase({
    required this.repository
  });

  Future<List<OrderEntity>?> call() async{
    return await  repository.getAllOrders();
  }
}


class CreateOrderUseCase {
  final OrderRepository repository; 

  CreateOrderUseCase({
    required this. repository
  });

  Future<void> call(OrderEntity order) async {
    return await repository.createOrder(order);
  }
}