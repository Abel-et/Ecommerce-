import 'package:flutter/material.dart';

class CheckoutButton extends StatelessWidget {
  final String paymentMethod;
  final VoidCallback onPressed;
  const CheckoutButton({
    super.key,
    required this.paymentMethod,
    required this.onPressed
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:  52,
      width: double.infinity,
      child:  ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black87,
        foregroundColor: Colors.white),
        onPressed: onPressed,
        child: Text(
          paymentMethod == 'cash' ? 'Place order' : 'Pay Now'
        ),
      ),
    );
  }
}