import 'package:ecommerce/core/database/app_database.dart';
import 'local_data_source.dart';
import 'package:ecommerce/features/products/data/model/product_Model.dart';



class LocalDataSourceImpl  implements
LocalDataSource{
  final AppDatabase appDatabase;

  LocalDataSourceImpl({required this.appDatabase});

// fetch all product from database
  @override
  Future<List<ProductModel>> getAllProducts() async{
    
    final allProducts = await appDatabase.fetchAllProducts();
    return allProducts;
  }


  // fetch single  product from database
  @override
  Future<ProductModel?> getProductById( String id) async{
     return await appDatabase.fetchProductById(id);
    
  }

  // create product 
  @override
  Future<void> createProduct(ProductModel product) async{
    await appDatabase.insertProduct(product);
  }


  // update product
  @override
  Future<void> updateProduct(ProductModel product) async{
    await appDatabase.updateProduct(product);
  }

  // delete product
  @override
  Future<void> deleteProduct( String id) async{
    await appDatabase.deleteProduct(id);
  }
}