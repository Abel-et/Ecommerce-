import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_state.dart';
import 'package:ecommerce/features/products/presentation/pages/cart/order_success_page.dart';
import 'package:ecommerce/features/products/presentation/widget/checkout/checkout_button.dart';
import 'package:ecommerce/features/products/presentation/widget/checkout/order_summary_section.dart';
import 'package:ecommerce/features/products/presentation/widget/checkout/payment_details_field.dart';
import 'package:ecommerce/features/products/presentation/widget/checkout/payment_method_section.dart';
import 'package:ecommerce/features/products/presentation/widget/checkout/shipping_address_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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


  @override
  void dispose(){
    _paymentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        CheckoutButton(paymentMethod: _payMethod, onPressed: (){
                      context.read<CartBloc>().add(ClearCartEvent());
                        _submitOreder();
                        })
                    ],
                  ),
                )
              ],
            ),

            ),
            
          )
        ],
      ),
    );
  }
  void _submitOreder(){
    
    Navigator.push(context, MaterialPageRoute(builder: (_)=> OrderSuccessPage()));
  }}


