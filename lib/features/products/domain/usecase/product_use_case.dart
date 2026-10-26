import 'package:ecommerce/features/products/domain/repository/product_repository.dart';
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;

  const GetAllProductsUseCase( this. repository);

  Future<List<ProductEntity>> call () async{ 
    return await repository.getAllProducts();
  }
}

class GetProductUseCase{
  final ProductRepository repository; 
  const GetProductUseCase( this.repository);

  Future<ProductEntity?> call(String id) async {
    return await repository.getProductById(id);
  }
}


class CreateProductUseCase {
  final ProductRepository repository ;
   const CreateProductUseCase( this.repository);


   Future<void> call(ProductEntity product) async{
    return await repository.createProduct(product);
   }
}


class UpdateProductUseCase{
final ProductRepository repository;

 const UpdateProductUseCase( this.repository);

 Future<void> call(ProductEntity product) async {
  return await repository.updateProduct(product);
 }

}


class DeleteProductUseCase{
  final ProductRepository repository;

  const DeleteProductUseCase( this.repository);

  Future<void> call(String id ) async{ 
    return await repository.deleteProduct(id);
  }
}
