import 'package:ecommerce/features/orders/domain/entity/order_entity.dart';
import 'package:ecommerce/features/orders/domain/use_case/order_use_case.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_event.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_state.dart';
import 'package:ecommerce/core/session/user_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase createOrderUseCase;
  final GetAllOrdersUseCase getAllOrdersUseCase;
  final UserSession userSession;

  OrderBloc({
    required this.createOrderUseCase,
    required this.getAllOrdersUseCase,
    required this.userSession,
  }) : super(OrderState.initial()) {
    // Register all combined event handlers
    on<GetAllOrdersEvent>(_onGetAllOrders);
    on<CreateOrderEvent>(_onCreateOrder);
    on<SearchOrdersEvent>(_onSearchOrders);
    on<FilterOrdersStatusEvent>(_onFilterOrdersStatus);
    on<ResetCreateStatusEvent>(_onResetCreateStatus);
  }

  /// 1. FETCH ALL ORDERS
  Future<void> _onGetAllOrders(
    GetAllOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(fetchStatus: OrderFetchStatus.loading));
    try {
      final userId = userSession.currentUser?.id;
      if (userId == null) {
        throw Exception('You must be signed in to view orders.');
      }

      final orders = await getAllOrdersUseCase(userId);
      
      emit(state.copyWith(
        fetchStatus: OrderFetchStatus.success,
        orders: orders,
        // Apply existing filters to the freshly loaded data
        visibleOrders: _applyFilters(orders, state.query, state.selectedStatus),
      ));
    } catch (e, stackTrace) {
      debugPrint('LOAD ORDERS FAILED: $e');
      debugPrintStack(stackTrace: stackTrace);
      emit(state.copyWith(
        fetchStatus: OrderFetchStatus.failure,
        fetchErrorMessage: _formatError(e),
      ));
    }
  }

  String _formatError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    return message.isEmpty ? 'Failed to load orders.' : message;
  }

  /// 2. CREATE A NEW ORDER
  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(createStatus: OrderCreateStatus.loading));
    try {
      await createOrderUseCase(event.order);
      
      // Add the new order immediately to the top of our local state list
      final updatedOrders = List<OrderEntity>.from(state.orders)..insert(0, event.order);

      emit(state.copyWith(
        createStatus: OrderCreateStatus.success,
        orders: updatedOrders,
        visibleOrders: _applyFilters(updatedOrders, state.query, state.selectedStatus),
      ));
    } catch (e) {
      emit(state.copyWith(
        createStatus: OrderCreateStatus.failure,
        createErrorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// 3. SEARCH THROUGH ORDERS
  void _onSearchOrders(SearchOrdersEvent event, Emitter<OrderState> emit) {
    emit(state.copyWith(
      query: event.query,
      visibleOrders: _applyFilters(state.orders, event.query, state.selectedStatus),
    ));
  }

  /// 4. FILTER ORDERS BY DROP-DOWN STATUS
  void _onFilterOrdersStatus(FilterOrdersStatusEvent event, Emitter<OrderState> emit) {
    emit(state.copyWith(
      selectedStatus: event.status,
      visibleOrders: _applyFilters(state.orders, state.query, event.status),
    ));
  }

  /// 5. RESET CREATION FLAGS
  void _onResetCreateStatus(ResetCreateStatusEvent event, Emitter<OrderState> emit) {
    emit(state.copyWith(createStatus: OrderCreateStatus.initial, createErrorMessage: null));
  }

 
  List<OrderEntity> _applyFilters(List<OrderEntity> orders, String query, String status) {
    return orders.where((order) {
      // Check search match (e.g. searching by Order ID string matching)
      final matchesSearch = order.id.toLowerCase().contains(query.toLowerCase());
      
      // Check status drop-down match
      final matchesStatus = status == 'All' || 
          order.status.name.toLowerCase() == status.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList();
  }
}
