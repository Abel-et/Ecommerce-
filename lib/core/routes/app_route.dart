import 'package:ecommerce/core/navigation/main_shell.dart';
import 'package:ecommerce/features/auth/presentation/pages/sign_in_page.dart';
import 'package:ecommerce/features/auth/presentation/pages/sign_up_page.dart';
import 'package:ecommerce/features/products/presentation/pages/cart/cart_page.dart';
import 'package:ecommerce/features/products/presentation/pages/product_pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';
  static const String cart = 'cart';
  static const String orders = 'orders';
  static const String profile = 'profile';
  static const String signup = 'signup';

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
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
        path: '/login',
        name: login,
        builder: (context, state) => SingInPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // tab 0
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),

          // tab 1, cart
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',// this page has checkout page , success page, 
                name: cart,
                builder: (context, state) => const CartPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile', // this page has order history , change information , 
                name: profile,
                builder: (context, state) => Scaffold(
                  body: Center(child: Text('profile Page will Implement soon')),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
