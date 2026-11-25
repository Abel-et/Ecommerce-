import 'package:ecommerce/features/products/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/product_bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_form_page.dart';

class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is Loading || state is InitialState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductFailure) {
            return Center(child: Text(state.messages));
          }
          if (state is! ProductLoaded || state.products.isEmpty) {
            return const Center(child: Text('No products available.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final product = state.products[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(product.imageUrl),
                    onBackgroundImageError: (_, _) {},
                    child: const Icon(Icons.image_outlined),
                  ),
                  title: Text(product.productName),
                  subtitle: Text(
                    '${product.productCategory} • ${product.productPrice} ETB',
                  ),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductFormPage(product: product),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProductFormPage()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }
}
