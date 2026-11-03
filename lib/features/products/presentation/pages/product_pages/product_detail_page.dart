import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailPage({
    super.key,
    required this.product
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Soft background contrast
      body: CustomScrollView(
        slivers: [
          // 1. Immersive Collapsing Image Header
          SliverAppBar(
            expandedHeight: 350.0,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black, // Dark color for back arrow
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-image-${product.productName}', // Optional: smooth screen transition
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover, 
                   errorBuilder: (_, _, _) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.black12,
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                  ),
                                );
                              },// Clean cut instead of stretching the image
                ),
              ),
            ),
          ),

          // 2. Product Details Body
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: -0.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Price Tag
                    Text(
                      '${product.productPrice} ETB',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Divider Line
                    Divider(color: Colors.grey[200], thickness: 1),
                    const SizedBox(height: 20),

                    // Description Header
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description Text
                    Text(
                      product.productDescription,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.grey[600],
                        height: 1.5, // Better line spacing for readability
                      ),
                    ),
                    
                    // Extra spacing so content isn't blocked by the bottom bar
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // 3. Floating Bottom Call-To-Action Menu
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 20, 
          right: 20, 
          bottom: MediaQuery.of(context).padding.bottom + 12, 
          top: 12
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          onPressed: () {
            context.read<CartBloc>().add( AddToCart(product));
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 20),
              SizedBox(width: 8),
              Text(
                'Add to Cart',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
