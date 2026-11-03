import 'package:ecommerce/core/session/user_session.dart';
import 'package:ecommerce/features/products/presentation/pages/cart/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../bloc/cart_bloc/cart_event.dart';
import '../../bloc/cart_bloc/cart_state.dart';


final sl = GetIt.instance;
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String _money(double amount) => '\$${amount.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // Empty cart.
        if (state.items.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                ),
                SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('Add a product to get started.'),
              ],
            ),
          );
        }

        // Cart containing products.
        return
         Scaffold(
          appBar: AppBar(
            title:   Text(
                    'Your Cart (${state.totalQuantity})',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
          ),),
           body: Column(
            children: [
       
              // Product list.
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
           
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            // Product image.
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.product.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.black12,
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                    ),
                                  );
                                },
                              ),
                            ),
           
                            const SizedBox(width: 12),
           
                            // Product information and quantity controls.
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.productName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                "${ _money(
                                    item.product.productPrice)} ETB"
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        visualDensity:
                                            VisualDensity.compact,
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                            DecreaseQuantity(
                                              item.product.productId,
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                        ),
                                      ),
                                      Text('${item.quantity}'),
                                      IconButton(
                                        visualDensity:
                                            VisualDensity.compact,
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                            IncreaseQuantity(
                                              item.product.productId,
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
           
                            // Remove the product.
                            IconButton(
                              tooltip: 'Remove product',
                              onPressed: () {
                                context.read<CartBloc>().add(
                                  RemoveFromCart(
                                    item.product.productId,
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
           
              // Order summary.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      label: 'Subtotal',
                      value: _money(state.totalPrice),
                    ),
                    const SizedBox(height: 8),
                    _SummaryRow(
                      label: 'Shipping',
                      value: _money(state.shipping),
                    ),
                    const Divider(height: 24),
                    _SummaryRow(
                      label: 'Total',
                      value: _money(state.total),
                      bold: true,
                    ),
                    const SizedBox(height: 16),
           
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style:  ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black87
                        ),
                        onPressed: () {
                          final user = sl<UserSession>().currentUser;
                         if(user == null){
                              ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please log in to continue to checkout.')),
    );
                            return;
                          }
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>
                          CheckoutPage(
                            currentUser : user,
                           
                          )));
                        },
                        child: Text(
                          'Checkout - ${_money(state.total)}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
                   ),
         );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 17 : 14,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}