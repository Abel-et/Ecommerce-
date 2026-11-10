import 'package:ecommerce/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  // final int productId;
  // final String productName;
  // final String productDescription;
  // final double productPrice;
  // final String imageUrl;
  // final String productCategory ;
  //  DateTime createdAt;

  ProductModel({
    required super.productId,
    required super.productName,
    required super.productDescription,
    required super.productPrice,
    required super.imageUrl,
    required super.productCategory,
    required super.createdAt,
  });

  //   this is the data comes from (Sql => to Model)
factory ProductModel.formSql(Map<String, dynamic> map) {
  return ProductModel(
    productId: map['id'],
    productName: map['name'],
    productDescription: map['description'],
    productPrice: (map['price'] as num).toDouble(),
    imageUrl: map['image_url'],
    productCategory: map['category'],
    createdAt: DateTime.parse(map['created_at']),
  );
}
  // the data comes from (model => sql)
 Map<String, dynamic> toSql() {
  return {
    'id': productId,
    'name': productName,
    'description': productDescription,
    'price': productPrice,
    'image_url': imageUrl,
    'category': productCategory,
    'created_at': createdAt.toIso8601String(),
  };
}

  // the data comes from entity and convet to model (Entity => model)
  factory ProductModel.fromEntity(ProductEntity product) {
    return ProductModel(
      productId: product.productId,
      productName: product.productName,
      productDescription: product.productDescription,
      productPrice: product.productPrice,
      imageUrl: product.imageUrl,
      productCategory: product.productCategory,
      createdAt: product.createdAt,
    );
  }

  // the data comes from model and converted to entity (model => Entity)
  ProductEntity toEntity() {
    return ProductEntity(
      productId: productId,
      productName: productName,
      productDescription: productDescription,
      productPrice: productPrice,
      imageUrl: imageUrl,
      productCategory: productCategory,
      createdAt: createdAt,
    );
  }
}
