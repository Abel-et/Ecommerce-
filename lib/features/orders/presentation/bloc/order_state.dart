import 'package:ecommerce/features/orders/domain/entity/order_entity.dart';
import 'package:equatable/equatable.dart';

// 1. Separate operational enums to avoid state conflicts
enum OrderFetchStatus { initial, loading, success, failure }
enum OrderCreateStatus { initial, loading, success, failure }

class OrderState extends Equatable {
  // Fetching & List Properties
  final OrderFetchStatus fetchStatus;
  final List<OrderEntity> orders;
  final List<OrderEntity> visibleOrders;
  final String query;
  final String selectedStatus;
  final String? fetchErrorMessage;

  // Creating Properties
  final OrderCreateStatus createStatus;
  final String? createErrorMessage;

  const OrderState({
    required this.fetchStatus,
    required this.orders,
    required this.visibleOrders,
    this.query = '',
    this.selectedStatus = 'All',
    this.fetchErrorMessage,
    required this.createStatus,
    this.createErrorMessage,
  });

  // Factory constructor to provide clean default values to your Bloc
  factory OrderState.initial() {
    return const OrderState(
      fetchStatus: OrderFetchStatus.initial,
      orders: [],
      visibleOrders: [],
      createStatus: OrderCreateStatus.initial,
    );
  }

  // copyWith allows you to update one side without blowing away the other
  OrderState copyWith({
    OrderFetchStatus? fetchStatus,
    List<OrderEntity>? orders,
    List<OrderEntity>? visibleOrders,
    String? query,
    String? selectedStatus,
    String? fetchErrorMessage,
    OrderCreateStatus? createStatus,
    String? createErrorMessage,
  }) {
    return OrderState(
      fetchStatus: fetchStatus ?? this.fetchStatus,
      orders: orders ?? this.orders,
      visibleOrders: visibleOrders ?? this.visibleOrders,
      query: query ?? this.query,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      fetchErrorMessage: fetchErrorMessage ?? this.fetchErrorMessage,
      createStatus: createStatus ?? this.createStatus,
      // Pass null explicitly or clear errors via fallback checks if needed
      createErrorMessage: createErrorMessage ?? this.createErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        fetchStatus,
        orders,
        visibleOrders,
        query,
        selectedStatus,
        fetchErrorMessage,
        createStatus,
        createErrorMessage,
      ];
}
