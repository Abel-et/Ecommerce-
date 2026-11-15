import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/orders/presentation/bloc/order_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/cart_bloc/cart_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:ecommerce/features/products/presentation/bloc/product_bloc/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/settings/app_settings.dart';
import 'core/routes/app_route.dart';
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();
  //   await AppDatabase.instance.seedProducts(
  //   ProductFakeData.products,
  // );

  runApp(const CommerceApp());
}

class CommerceApp extends StatelessWidget {
  const CommerceApp({super.key});

  static const Color appBackgroundColor = Color(0xFFF8F9FA);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(
          create: (context) => sl<ProductBloc>()..add(GetAllProductsEvent()),
        ),
        BlocProvider<CartBloc>(create: (_) => CartBloc()),
        BlocProvider<OrderBloc>(create: (context) => sl<OrderBloc>()),
      ],

      child: ListenableBuilder(
        listenable: sl<AppSettings>(),
        builder: (context, _) => MaterialApp.router(
          title: 'E-Commerce App',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRoute.router,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: appBackgroundColor,
          ),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
          themeMode: sl<AppSettings>().themeMode,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(sl<AppSettings>().fontScale),
              ),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
