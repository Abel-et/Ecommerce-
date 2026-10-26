
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecommerce/features/auth/presentation/pages/sign_up_page.dart';

class AppRoute {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';

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
        path: '/login',
        name: login,
        builder: (context, state) => SignUpPage(),
      ),
      GoRoute(
        path: '/home',
        name: home,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home page')),
        ),
      ),
    ],
  );
}
