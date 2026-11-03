import 'package:ecommerce/features/products/data/model/product_Model.dart';
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
// import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:ecommerce/features/products/domain/usecase/product_use_case.dart';

// import 'package:flutter/foundation.dart';
import 'product_event.dart';
import 'product_state.dart';

import "package:flutter_bloc/flutter_bloc.dart";

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetProductUseCase getProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;

  List<ProductEntity> _allProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  ProductBloc({
    required this.getAllProductsUseCase,
    required this.getProductUseCase,
    required this.deleteProductUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
  }) : super(InitialState()) {
    on<CreateProductEvent>(_createProduct);
    on<UpdateProductEvent>(_updateProduct);
    on<DeleteProductEvent>(_deleteProduct);
    on<GetAllProductsEvent>(_getAllProducts);
    on<GetProductEvent>(_getProductById);
    on<SearchedProductEvent>(_onSearchProduct);
    on<FilterProductsByCategoryEvent>(_onFilterProductsByCategory);
  }

  Future<void> _createProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(Loading());
    await createProductUseCase(event.product);
  }

  Future<void> _updateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(Loading());
    // # passing for update product
    await updateProductUseCase(event.product);
  }

  Future<void> _deleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(Loading());
    await deleteProductUseCase(event.id);
  }

  Future<void> _getAllProducts(
    GetAllProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(Loading());

    try {
      _allProducts = ProductFakeData.products;
      _emitLoaded(emit);
    } catch (error) {
      emit(ProductFailure('unable to load products'));
    }
  }


void _onFilterProductsByCategory(
  FilterProductsByCategoryEvent event,
  Emitter<ProductState> emit
){
  _selectedCategory = event.category;
  _emitLoaded(emit);
}
  void _onSearchProduct( 
    SearchedProductEvent event,
    Emitter<ProductState> emit
  ) async{
   

    _searchQuery = event.query;
    _emitLoaded(emit);
  

  }

 

  void _emitLoaded(Emitter<ProductState> emit)
  {
    final query =  _searchQuery.trim().toLowerCase();
    final category = _selectedCategory.trim().toLowerCase();
    final visibleProduct = _allProducts.where((product){


      final matchesQuery = query.isEmpty ||  product.productName.toLowerCase().contains(query) || 
      product.productCategory.toLowerCase().contains(query);
      
      final matchesCategory = category == 'all' || product.productCategory.trim().toLowerCase() == category;
      return matchesCategory  && matchesQuery;
    });

    emit( 
      ProductLoaded(
        products: List<ProductEntity>.unmodifiable(_allProducts),
        visibleProducts: List<ProductEntity>.unmodifiable(visibleProduct),
        query: query,
        selectedCategory: category
        
      )
    );
  }

  Future<void> _getProductById(
    GetProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(Loading());
    try {
      final product = await getProductUseCase(event.id);
      if (product != null) {
        emit(ProductDetailLoaded(product));
      } else {
        emit(ProductFailure('un able to access this product'));
      }
    } catch (error) {
      emit(ProductFailure(' something goes wrong ${error.toString()}'));
    }
  }
}

class ProductFakeData {
  ProductFakeData._();

  static final List<ProductModel> products = [
    ProductModel(
      productId: '1',
      productName: 'Wireless Headphones',
      productDescription: 'Comfortable wireless headphones with rich sound and long battery life.',
      productPrice: 2499.00,
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600',
      productCategory: 'Electronics',
      createdAt: DateTime(2026, 10, 1),
    ),
    ProductModel(
      productId: '2',
      productName: 'Running Sneakers',
      productDescription: 'Lightweight everyday sneakers for walking, running, and casual wear.',
      productPrice: 1899.00,
      imageUrl:
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600',
      productCategory: 'Shoes',
      createdAt: DateTime(2026, 10, 2),
    ),
    ProductModel(
      productId: '3',
      productName: 'Classic Wristwatch',
      productDescription: 'A minimalist wristwatch suitable for everyday use and formal occasions.',
      productPrice: 3299.00,
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600',
      productCategory: 'Accessories',
      createdAt: DateTime(2026, 10, 3),
    ),
    ProductModel(
      productId: '4',
      productName: 'Leather Backpack',
      productDescription:
          'A stylish backpack with enough room for your daily essentials.',
      productPrice: 2199.00,
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600',
      productCategory: 'Bags',
      createdAt: DateTime(2026, 10, 4),
    ),
    ProductModel(
      productId: '5',
      productName: 'Smartphone',
      productDescription: 'A modern smartphone for communication, photography, and entertainment.',
      productPrice: 24999.00,
      imageUrl:
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600',
      productCategory: 'Electronics',
      createdAt: DateTime(2026, 10, 5),
    ),
    ProductModel(
      productId: '6',
      productName: 'Casual T-Shirt',
      productDescription:
          'A comfortable everyday T-shirt with a simple, versatile design.',
      productPrice: 599.00,
      imageUrl:
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=600',
      productCategory: 'Fashion',
      createdAt: DateTime(2026, 10, 6),
    ),
    ProductModel(
      productId: '7',
      productName: 'Sunglasses',
      productDescription:
          'Modern sunglasses for everyday style and outdoor activities.',
      productPrice: 899.00,
      imageUrl:
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=600',
      productCategory: 'Accessories',
      createdAt: DateTime(2026, 10, 7),
    ),
    ProductModel(
      productId: '8',
      productName: 'Travel Water Bottle',
      productDescription: 'A reusable bottle for keeping water close while travelling or exercising.',
      productPrice: 349.00,
      imageUrl:
          'https://images.unsplash.com/photo-1602143407151-7111542de6e8?w=600',
      productCategory: 'Lifestyle',
      createdAt: DateTime(2026, 10, 8),
    ),
  ];
}
