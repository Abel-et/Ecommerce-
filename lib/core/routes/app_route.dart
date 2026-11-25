import 'package:ecommerce/core/navigation/main_shell.dart';
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:ecommerce/features/auth/presentation/pages/sign_in_page.dart';
import 'package:ecommerce/features/auth/presentation/pages/sign_up_page.dart';
import 'package:ecommerce/features/auth/presentation/pages/profile_page.dart';
import 'package:ecommerce/features/auth/presentation/pages/onboarding_page.dart';
import 'package:ecommerce/features/orders/presentation/pages/orders_page.dart';
import 'package:ecommerce/features/products/domain/entities/product_entity.dart';
import 'package:ecommerce/features/products/presentation/pages/cart/cart_page.dart';
import 'package:ecommerce/features/products/presentation/pages/cart/order_success_page.dart';
import 'package:ecommerce/features/products/presentation/pages/cart/checkout_page.dart';
import 'package:ecommerce/features/products/presentation/pages/product_pages/home_page.dart';
import 'package:ecommerce/features/products/presentation/pages/product_pages/product_detail_page.dart';
import 'package:ecommerce/features/products/presentation/pages/admin/admin_products_page.dart';
import 'package:ecommerce/features/products/presentation/pages/admin/product_form_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  // Route Names
  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';
  static const String cart = 'cart';
  static const String orders = 'orders';
  static const String profile = 'profile';
  static const String signup = 'signup';
  static const String orderSuccess = 'order-success';
  static const String productDetails = 'product-details';
  static const String checkout = 'checkout';
  static const String ordersPage = 'orders_page';
  static const String onboarding = 'onboarding';
  static const String adminProducts = 'admin-products';
  static const String addProduct = 'add-product';
  static const String editProduct = 'edit-product';

  // * Navigator keys
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final homeNavigatorKey = GlobalKey<NavigatorState>();
  static final profileNavigatorKey = GlobalKey<NavigatorState>();
  static final cartNavigatorKey = GlobalKey<NavigatorState>();
  static final orderNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // ** Authentication
      GoRoute(
        path: '/',
        name: splash,
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'E-COMMERCE APP',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.goNamed(AppRoute.login),
                  child: const Text('Go to Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/signup',
        name: signup,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        name: login,
        builder: (context, state) => SingInPage(),
      ),

      // * Main Application shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // * Home Branch
          StatefulShellBranch(
            navigatorKey: homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                name: home,
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'product/:productId',
                    name: productDetails,
                    builder: (context, state) {
                      final product = state.extra as ProductEntity;
                      return ProductDetailPage(product: product);
                    },
                  ),
                ],
              ),
            ],
          ),

          //  ** cart Branch
          StatefulShellBranch(
            navigatorKey: cartNavigatorKey,
            routes: [
              GoRoute(
                path: '/cart',
                name: cart,
                builder: (context, state) => const CartPage(),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: orderNavigatorKey,
            routes: [
              GoRoute(
                path: '/orders_page',
                name: ordersPage,
                builder: (context, state) => const OrdersPage(),
              ),
            ],
          ),
          // ** Profile page
          StatefulShellBranch(
            navigatorKey: profileNavigatorKey,
            routes: [
              GoRoute(
                path: '/profile', // this page has order history , change information ,
                name: profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      //  ** Global Transaction Routes
      GoRoute(
        path: '/checkout',
        name: checkout,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return CheckoutPage(currentUser: user);
        },
      ),
      GoRoute(
        path: '/order-success',
        name: orderSuccess,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const OrderSuccessPage(),
      ),
      GoRoute(
        path: '/admin/products',
        name: adminProducts,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AdminProductsPage(),
      ),
      GoRoute(
        path: '/admin/products/add',
        name: addProduct,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ProductFormPage(),
      ),
      GoRoute(
        path: '/admin/products/edit',
        name: editProduct,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          return ProductFormPage(product: state.extra as ProductEntity);
        },
      ),
    ],
  );
}
