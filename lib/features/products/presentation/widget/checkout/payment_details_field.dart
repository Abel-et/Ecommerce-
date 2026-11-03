import 'package:flutter/material.dart';

class PaymentDetailsField extends StatelessWidget {
  final String method;
  final TextEditingController controller;
  const PaymentDetailsField({
    super.key,
    required this.controller,
    required this.method
    });

  @override
  Widget build(BuildContext context) {
    final isTelebirr = method == 'telebirr';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isTelebirr? 'Phone Number' : 'Account Number',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold
          ),
        ),

        const SizedBox(height: 12,),

        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: isTelebirr ? ' 912345678' : '1000530959149',
            prefixText: isTelebirr ? '+251 ' : null,prefixStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13)
            ) 
          ),
          validator: (value){
            final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');

            if(isTelebirr && (digits.length < 8 || digits.length > 9)){
              return 'Enter a valid phone number';
            }
            if(!isTelebirr && (digits.length != 13)){
              return 'Enter a valid account number';
            }
          return null;
          },
        )
      ],
    );
  }
}