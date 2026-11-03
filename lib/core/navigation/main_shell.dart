import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_bloc.dart';

import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_state.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // displays the current  selected tab
      body: navigationShell,

      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,

        backgroundColor: Colors.transparent,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },

        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),

          NavigationDestination(
            // 1. Unselected state: Shows the icon wrapped inside the BlocBuilder Badge
            icon: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final count = state.totalQuantity;
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text(count > 99 ? '99+' : '$count'),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                  ), // Using outlined for unselected state
                );
              },
            ),
            // 2. Selected state: Mirror the same BlocBuilder so the badge stays visible when the tab is active
            selectedIcon: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                final count = state.totalQuantity;
                return Badge(
                  isLabelVisible: count > 0,
                  label: Text(count > 99 ? '99+' : '$count'),
                  child: const Icon(
                    Icons.shopping_cart,
                  ), // Filled icon for selected state
                );
              },
            ),
            label: 'Cart',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
