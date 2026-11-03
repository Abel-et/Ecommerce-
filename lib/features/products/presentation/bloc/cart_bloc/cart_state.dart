
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';

class CartItem{
  final ProductEntity product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity
  });

  // total price of for particular cart item.
  double get lineTotal => product.productPrice * quantity;

  CartItem copyWith({ int? quantity}){
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
}



class CartState{
  final List<CartItem> items; 

  CartState({List<CartItem> items = const []}) : items = List.unmodifiable(items);

  int get totalQuantity{
    return items.fold<int>(0,
    (sum, item) => sum + item.quantity);
  }

  double get totalPrice{
    return items.fold(0.0, 
    (sum, item) => sum + item.lineTotal);
  }

  double get shipping{
    return items.isEmpty ? 0.0 : 50.0;
  }

  double get total => totalPrice + shipping;
}