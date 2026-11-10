import 'package:ecommerce/features/products/data/data_sources/local/local_data_source.dart';
import 'package:ecommerce/features/products/data/model/product_model.dart';
import 'package:ecommerce/features/products/domain/repository/product_repository.dart';
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';

class ProductRepositoryImpl implements ProductRepository{
  final LocalDataSource localDataSource;
   ProductRepositoryImpl({ required this.localDataSource});

  @override
  Future<List<ProductEntity>> getAllProducts() async{
    final products = await localDataSource.getAllProducts();
    return products.map((product) => product.toEntity()).toList();
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    final productModel = await localDataSource.getProductById(id);
    if(productModel != null){
      return productModel.toEntity();
    }
    return null;
    
  }

  @override
  Future<void> createProduct(ProductEntity product) async {
    // convert into product mode and pass it 
    final productModel = ProductModel.fromEntity(product);
        await localDataSource.createProduct(productModel);

  }

  @override
  Future <void> updateProduct(ProductEntity product) async {
    final productModel = ProductModel.fromEntity(product);
    await localDataSource.updateProduct(productModel);
  }

  @override
  Future<void> deleteProduct(String id) async{
     await localDataSource.deleteProduct(id);
  }
}


