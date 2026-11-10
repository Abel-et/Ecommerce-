
import 'order_items.dart';

enum OrderStatus {pending, processing, completed}

class OrderEntity {
  final String id;
  final String userId;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt ; 
  final List<OrderItems> items ; 


  const OrderEntity({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items
  });

  bool get isTotalValid{
    final calculateTotal = items.fold<double>( 0, (sum , item) => sum + item.totalRowPrice);
    return (calculateTotal - totalAmount).abs() < 0.01;
  }

}