import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class InitialState extends ProductState {}

class Loading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductEntity> products;
  final List<ProductEntity> visibleProducts;
  final String query;
  final String selectedCategory;

  const ProductLoaded({
    required this.products,
    required this.visibleProducts,
    this.query = '',
    this.selectedCategory = 'All',
  });

  @override
  List<Object?> get props => [
    products,
    visibleProducts,
    query,
    selectedCategory,
  ];
}

class ProductDetailLoaded extends ProductState {
  final ProductEntity product;
  const ProductDetailLoaded(this.product);
}

class ProductFailure extends ProductState {
  final String messages;
  const ProductFailure(this.messages);
}
