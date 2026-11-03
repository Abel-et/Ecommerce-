import 'cart_event.dart';
import 'cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CartBloc extends Bloc<CartEvent, CartState>{
  CartBloc():super(CartState()){
    on<AddToCart>(_onAddToCart);
    on<IncreaseQuantity>(_onIncreaseQuantity);
    on<DecreaseQuantity>(_onDecreaseQuantity);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCartEvent>((event, emit) => emit(CartState()),);
  }


  void _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit
  ) async{
    final updatedItems = List<CartItem>.from(state.items);

    final index = updatedItems.indexWhere(
      (item) => item.product.productId == event.product.productId
    );

    if(index >= 0){
      final existingItem = updatedItems[index];

      updatedItems[index] = existingItem.copyWith(
        quantity: existingItem.quantity + 1
      );
    } else{
      updatedItems.add( 
        CartItem(product: event.product, quantity: 1)
      );
    }
    emit(CartState(items: updatedItems));
  }


  void _onIncreaseQuantity(
    IncreaseQuantity event,
    Emitter<CartState> emit
  ){
    final updatedItems = state.items.map((item){
      if(item.product.productId == event.productId){
        return item.copyWith(
          quantity: item.quantity + 1
        );
      }
      return item;
    }).toList();
    emit(CartState(items: updatedItems));
  }

  void _onDecreaseQuantity(
    DecreaseQuantity event,
    Emitter<CartState> emit
  ){
    final updatedItems = state.items.map((item){
      if(item.product.productId == event.productId){
        return item.copyWith(
         
          quantity: item.quantity - 1
        );
       
      }
      return item;
    }).where((item)=> item.quantity > 0 )
    .toList();
    emit(CartState(items: updatedItems));
  }


void _onRemoveFromCart(
RemoveFromCart event,
Emitter<CartState>emit
){
  final updatedItems = state.items.where((item) => item.product.productId != event.productId).toList();
  emit(CartState(items: updatedItems));
}
}