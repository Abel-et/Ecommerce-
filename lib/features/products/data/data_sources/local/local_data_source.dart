import 'package:ecommerce/features/products/data/model/product_model.dart';

abstract class LocalDataSource {
  Future<List<ProductModel>> getAllProducts(); 
  Future<ProductModel?> getProductById(String id);
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}