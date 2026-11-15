import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/routes/app_route.dart';
import 'package:ecommerce/core/session/user_session.dart';
import 'package:ecommerce/features/orders/domain/entity/order_entity.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_bloc.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_event.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_state.dart';
import 'package:ecommerce/features/products/presentation/widget/category_chips.dart';
import 'package:ecommerce/features/products/presentation/widget/orders/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();

    if (sl<UserSession>().currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.goNamed(AppRoute.login);
        }
      });
      return;
    }

    // Fetch orders when this page is initialized.
    context.read<OrderBloc>().add(GetAllOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Page heading
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Orders',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (query) {
                context.read<OrderBloc>().add(SearchOrdersEvent(query));
              },
              decoration: InputDecoration(
                hintText: 'Search by order ID...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Status filter
          BlocSelector<OrderBloc, OrderState, String>(
            selector: (state) => state.selectedStatus,
            builder: (context, selectedStatus) {
              const statuses = [
                ('All', 'All Orders'),
                ('Pending', 'Pending'),
                ('Processing', 'Processing'),
                ('Completed', 'Completed'),
              ];

              return SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: statuses.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final (value, label) = statuses[index];

                    return CategoryChips(
                      label: label,
                      isSelected: selectedStatus == value,
                      onTap: () {
                        context.read<OrderBloc>().add(
                          FilterOrdersStatusEvent(value),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // Main content: depends on fetch status
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                switch (state.fetchStatus) {
                  case OrderFetchStatus.initial:
                    return const Center(
                      child: Text('Preparing your orders...'),
                    );

                  case OrderFetchStatus.loading:
                    return const Center(child: CircularProgressIndicator());

                  case OrderFetchStatus.failure:
                    return _buildError(context, state.fetchErrorMessage);

                  case OrderFetchStatus.success:
                    if (state.visibleOrders.isEmpty) {
                      return _buildEmpty(state);
                    }

                    return _buildOrdersList(state.visibleOrders);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message ?? 'Failed to load orders.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                context.read<OrderBloc>().add(GetAllOrdersEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(OrderState state) {
    final hasNoOrders = state.orders.isEmpty;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            hasNoOrders ? Icons.shopping_bag_outlined : Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 12),
          Text(
            hasNoOrders
                ? 'You have no orders yet.'
                : 'No matching orders found.',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          if (!hasNoOrders)
            TextButton(
              onPressed: () {
                context.read<OrderBloc>().add(SearchOrdersEvent(''));
                context.read<OrderBloc>().add(FilterOrdersStatusEvent('All'));
              },
              child: const Text('Clear filters'),
            ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<OrderEntity> orders) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrderBloc>().add(GetAllOrdersEvent());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return OrderCard(order: orders[index]);
        },
      ),
    );
  }
}
