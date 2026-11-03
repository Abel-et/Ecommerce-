
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable{
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class CreateProductEvent extends ProductEvent{
  final ProductEntity product;
  
const   CreateProductEvent( {
    required this.product
  });
}

class UpdateProductEvent extends ProductEvent{
  final ProductEntity product;
  const UpdateProductEvent( {
    required this.product
  });
}


class DeleteProductEvent extends ProductEvent{
  final String id; 
  const DeleteProductEvent( this.id);
}

class GetAllProductsEvent extends ProductEvent{
  
  const GetAllProductsEvent();

}

class SearchedProductEvent extends ProductEvent{
  final String query; 
   const SearchedProductEvent(
    this.query
  );
  @override
  List<Object?> get props => [ query];
}

class GetProductEvent extends ProductEvent{
  final String id;
 const GetProductEvent( this.id);
}

class FilterProductsByCategoryEvent extends ProductEvent{
  final String category;

  const FilterProductsByCategoryEvent({
    required this.category
  });
  @override
  List<Object?> get props =>[category];
}