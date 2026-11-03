import 'package:ecommerce/features/products/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/product_bloc/product_event.dart';
import 'package:ecommerce/features/products/presentation/bloc/product_bloc/product_state.dart';
import 'package:ecommerce/features/products/presentation/widget/category_chips.dart';
import 'package:ecommerce/features/products/presentation/widget/product_card.dart';
import 'package:ecommerce/features/products/presentation/widget/search_bar.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController searchedProduct;

  @override
  void initState() {
    super.initState();
    searchedProduct = TextEditingController();
  }

  @override
  void dispose() {
    searchedProduct.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                'Online Shopping ',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              pinned: false,
              floating: false,
              backgroundColor: Colors.white,
              elevation: 3,
              actions: [
                IconButton(
                  tooltip: 'notification',
                  onPressed: () {},
                  icon: Icon(Icons.notifications_outlined, size: 30),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: HomeSearchBar(
                  controller: searchedProduct,
                  onChanged: (query) {
                    context.read<ProductBloc>().add(
                      SearchedProductEvent(query),
                    );
                  },
                ),
              ),
            ),

            // for category chip
            BlocBuilder<ProductBloc, ProductState>(
              builder: (((context, state) {
                if (state is! ProductLoaded) {
                  return const SliverToBoxAdapter(child: SizedBox(height: 12));
                }

                final categories = <String>[
                  'All',
                  ...state.products
                      .map((product) => product.productCategory)
                      .where((category) => category.trim().isNotEmpty)
                      .toSet(),
                ];

                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return CategoryChips(
                          label: category,
                          onTap: () {
                            context.read<ProductBloc>().add(
                              FilterProductsByCategoryEvent(category: category),
                            );
                          },
                          isSelected:
                              state.selectedCategory.toLowerCase() ==
                              category.toLowerCase(),
                        );
                      },
                    ),
                  ),
                );
              })),
            ),
            BlocBuilder<ProductBloc, ProductState>(
              builder: ((context, state) {
                if (state is Loading) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(25),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }

                if (state is ProductLoaded) {
                  final products = state.visibleProducts;

                  if (products.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          state.query.trim().isEmpty
                              ? 'No Products available'
                              : 'No products found for "${state.query}"',
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      }, childCount: products.length),
                    ),
                  );
                }

                if (state is ProductFailure) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Center(
                        child: Column(
                          children: [
                            Text(state.messages),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ProductBloc>().add(
                                  GetAllProductsEvent(),
                                );
                              },
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }),
            ),
          ],
        ),
      ),
    );
  }
}
