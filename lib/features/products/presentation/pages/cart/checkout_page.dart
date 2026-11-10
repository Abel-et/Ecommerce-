import 'package:ecommerce/core/routes/app_route.dart';
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:ecommerce/features/orders/domain/entity/order_items.dart';
import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:ecommerce/features/products/presentation/widget/checkout/checkout_button.dart';
import 'package:ecommerce/features/products/presentation/widget/checkout/order_summary_section.dart';
import 'package:ecommerce/features/products/presentation/widget/checkout/payment_details_field.dart';
import 'package:ecommerce/features/products/presentation/widget/checkout/payment_method_section.dart';
import 'package:ecommerce/features/products/presentation/widget/checkout/shipping_address_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/features/orders/domain/entity/order_entity.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_bloc.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_event.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_state.dart';
import 'package:uuid/uuid.dart';

class CheckoutPage extends StatefulWidget {
  final UserEntity currentUser;
  const CheckoutPage({
    super.key,
    required this.currentUser
    });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _payMethod = 'telebirr';
  final _paymentController = TextEditingController();

  final Uuid _uuid = const Uuid();
  void _placeOrder(){
    if(_formKey.currentState?.validate() !=true){
      return;
    }

    final orderBloc = context.read<OrderBloc>();
    if(orderBloc.state.createStatus == OrderCreateStatus.loading){
      return;
    }

    final cartState = context.read<CartBloc>().state;
    final cartItems = cartState.items;

    if(cartItems.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your cart is empty')),
    );
    return;
    }

    final orderItems = cartItems.map((cartItem){
      return OrderItems(id: _uuid.v4(), 
      productId: cartItem.product.productId, 
      quantity: cartItem.quantity, 
      priceAtPurchase: cartItem.product.productPrice);
    }).toList();

    final totalAmount = orderItems.fold<double>( 
      0, (sum, item) => sum + item.totalRowPrice
    );


    final order = OrderEntity(id: _uuid.v4(), 
    userId: widget.currentUser.id, 
    totalAmount: totalAmount, 
    status: OrderStatus.pending, 
    createdAt: DateTime.now(), 
    items: orderItems);

    orderBloc.add(CreateOrderEvent(order));
  }
  @override
  void dispose(){
    _paymentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc,OrderState>(
      listenWhen: (previous, current) => previous.createStatus != current.createStatus,
      listener: (context,state ){
        if(state.createStatus == OrderCreateStatus.success){
          context.read<CartBloc>().add(ClearCartEvent());
          context.read<OrderBloc>().add(ResetCreateStatusEvent());

          context.pushReplacement(AppRoute.orderSuccess);
        }

        if(state.createStatus == OrderCreateStatus.failure){
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.createErrorMessage ?? 'Order creation failed',
            ),
            backgroundColor: Colors.red,
          ),
        );
      
        }},
    child: Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('Checkout'),
            centerTitle: true,
          ),

          SliverToBoxAdapter(
            child:  Padding(padding: const EdgeInsets.all(16),
            child:  Column(
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                ShippingAddressSection(user: widget.currentUser),
                const SizedBox(height: 24,),
                Form(  
                  key: _formKey,
                  child: Column(
                    children: [
                      PaymentMethodSection(
                        selectedMethod: _payMethod, 
                        onChanged: (method){
                          setState(() {
                            _payMethod = method;
                            _paymentController.clear();
                          });
                        }),
                        const SizedBox(height: 20,),
                        if(_payMethod !='cash') 
                        PaymentDetailsField(controller: _paymentController, method: _payMethod),
                        const SizedBox(height: 24,),
                        const OrderSummarySection(),
                        const SizedBox(height: 24,),
                        CheckoutButton(paymentMethod: _payMethod, onPressed: _placeOrder)
                    ],
                  ),
                )
              ],
            ),

            ),
            
          )
        ],
      ),
    )
      );
  }
 


}

/**
 * here we have*
 *  1. product entity,
 *  2. user entity ,flutt
 */