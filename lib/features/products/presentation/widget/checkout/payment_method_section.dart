import 'package:flutter/material.dart';

class PaymentMethodSection extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onChanged;
  const PaymentMethodSection({
    super.key,
    required this.selectedMethod,
    required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final methods  = [
      
        ('telebirr', 'TeleBirr'),
        ('cbe' , 'CBE'),
        ("cash", 'Cash on Delivery')
      
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(  
          'Payment Method',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        ...methods.map((method){
          return RadioListTile<String>(  
            value: method.$1,
            groupValue: selectedMethod,
            onChanged: (value){
              if(value != null) onChanged(value);
            },
            title: Text(method.$2),
            contentPadding: EdgeInsets.zero,
          );
        })
      ],
    );
  }
}