
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/app_route.dart';
import 'core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(const CommerceApp());
}

class CommerceApp extends StatelessWidget {
  const CommerceApp({super.key});

  static const Color appBackgroundColor = Color(0xFFF8F9FA);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: MaterialApp.router(
        title: 'E-Commerce App',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRoute.router,

        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: appBackgroundColor,
          
        ),
      ),
    );
  }
}
