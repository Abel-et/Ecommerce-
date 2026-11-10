

import 'package:ecommerce/features/orders/data/model/order_item_model.dart';
import 'package:ecommerce/features/orders/domain/entity/order_entity.dart';

class OrderModel extends OrderEntity{
  OrderModel({
    required super.id,
    required super.userId,
    required super.totalAmount,
    required super.status,
    required super.items,
    required super.createdAt
  });


// CREATE TABLE orders ( 
//     id TEXT PRIMARY KEY,
//     user_id TEXT NOT NULL,
//     total_amount real NOT NULL,
//     status TEXT NOT NULL,
//     created_at TEXT NOT NULL,


  factory OrderModel.fromSql(Map<String, dynamic> orderMap, List<Map<String, dynamic>>itemListMap ){

  final statusString = orderMap['status'] as String;
  final parsedStatus = OrderStatus.values.firstWhere(
    (e) => e.name == statusString,
    orElse: () => OrderStatus.processing
  ) ;

  final parsedDate = DateTime(.parse(orderMap['create_at'] as String));

  final parseItems = itemListMap.map((itemMap) => OrderItemModel.fromDbMap(itemMap)).toList();

  return OrderModel(  
    id: orderMap['id'] as String,
    userId: orderMap['user_id'] as String,
    totalAmount: (orderMap['total_amount'] as num).toDouble(),
    status: parsedStatus,
    createdAt: parsedDate,
    items: parseItems
  );
}

  Map<String,dynamic>toDbMap(){
    return {
      'id' :id,
      'user_id': userId,
      'total_amount': totalAmount,
      'status' : status.name,
      'created_at' : createdAt.toIso8601String()
    };
  }


  factory OrderModel.fromEntity(OrderEntity entity){
    return OrderModel(id: entity.id,
     userId: entity.userId, 
     totalAmount: entity.totalAmount, 
     status: entity.status, 
     items: entity.items.map((item) => OrderItemModel.fromEntity(item)).toList(), 
     createdAt: entity.createdAt);
  }
}