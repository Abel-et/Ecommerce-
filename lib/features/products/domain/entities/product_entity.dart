class ProductEntity {
  final String productId;
  final String productName ;
  final String productDescription;
  final double productPrice;
  final String imageUrl;
  final String productCategory;
  final DateTime createdAt; 
   
   const ProductEntity({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.imageUrl,
    required this.productCategory,
    required this.createdAt,
   });

}