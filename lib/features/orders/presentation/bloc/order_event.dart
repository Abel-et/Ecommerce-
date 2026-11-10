import 'package:ecommerce/features/orders/domain/entity/order_entity.dart';
import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched to fetch all past orders from the database
class GetAllOrdersEvent extends OrderEvent {}

/// Dispatched when submitting a new order
class CreateOrderEvent extends OrderEvent {
  final OrderEntity order;

  const CreateOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

/// Dispatched when the user types in the search bar
class SearchOrdersEvent extends OrderEvent {
  final String query;

  const SearchOrdersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Dispatched when the user changes the status filter dropdown (e.g., 'Pending', 'Completed')
class FilterOrdersStatusEvent extends OrderEvent {
  final String status;

  const FilterOrdersStatusEvent(this.status);

  @override
  List<Object?> get props => [status];
}

/// Dispatched to reset the createStatus back to initial (useful for clearing success overlays)
class ResetCreateStatusEvent extends OrderEvent {}
