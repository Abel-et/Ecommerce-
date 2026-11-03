
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';

abstract class CartEvent {
  const CartEvent();
}


class AddToCart extends CartEvent{
  final ProductEntity product ;
  const AddToCart(this.product);
}
class IncreaseQuantity extends CartEvent{
  final String productId;
  const IncreaseQuantity(this.productId);
}

class DecreaseQuantity extends CartEvent{
  final String productId;
  const DecreaseQuantity(this.productId);
}


class RemoveFromCart extends CartEvent{
  final String productId;
  const RemoveFromCart(this.productId);
}

class ClearCartEvent extends CartEvent{}