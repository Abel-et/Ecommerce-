import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:ecommerce/features/products/presentation/widget/current_location_widget.dart';
import 'package:flutter/material.dart';
class ShippingAddressSection extends StatelessWidget {
  final UserEntity user;
  const ShippingAddressSection({
    super.key,
    required this.user}
    );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Shipping Address',
        style:  TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17
        ),),
        const SizedBox(height: 12,),
        CurrentLocationWidget(user: user),
      ],
    );
  }
}