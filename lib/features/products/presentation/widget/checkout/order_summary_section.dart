import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final total = state.total + state.shipping;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _summaryRow(
              'Items (${state.totalQuantity})',
              '\$${state.total.toStringAsFixed(2)}',
            ),

            _summaryRow(
              'Shipping',
              '\$${state.shipping.toStringAsFixed(2)}',
            ),

            const Divider(),

            _summaryRow(
              'Total',
              '\$${total.toStringAsFixed(2)}',
              bold: true,
            ),
          ],
        );
      },
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    final style = TextStyle(
      fontSize: bold ? 18 : 15,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}