
import 'package:ecommerce/core/session/user_session.dart';
import 'package:ecommerce/features/products/data/data_sources/local/local_data_source.dart';
import 'package:ecommerce/features/products/data/data_sources/local/local_data_source_impl.dart';
import 'package:ecommerce/features/products/data/repository/product_repository_impl.dart';
import 'package:ecommerce/features/products/domain/repository/product_repository.dart';
import 'package:ecommerce/features/products/domain/usecase/product_use_case.dart';
import 'package:ecommerce/features/products/presentation/bloc/product_bloc/product_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:ecommerce/core/database/app_database.dart';
import 'package:ecommerce/features/auth/data/repository/user_repository_impl.dart';
import 'package:ecommerce/features/auth/domain/repository/user_repository.dart';
import 'package:ecommerce/features/auth/domain/use_case/user_use_case.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/data/data_sources/local/user_local_data_source.dart';
import 'package:ecommerce/features/auth/data/data_sources/local/user_local_data_source_impl.dart';

// create instance of GetIt class
final sl = GetIt.instance;

Future<void> initDependencies() async {
  final dbInstance = AppDatabase.instance;

  await dbInstance.database;

  if (!sl.isRegistered<AppDatabase>()) {
    sl.registerSingleton<AppDatabase>(dbInstance);
  }

  if (!sl.isRegistered<UserLocalDataSource>()) {
    sl.registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(appDatabase: sl<AppDatabase>()),
    );
  }

  if(!sl.isRegistered<UserSession>()){
    sl.registerLazySingleton<UserSession>(
      () => UserSession(),
    );
  }

  if (!sl.isRegistered<UserRepository>()) {
    sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(localDataSource: sl<UserLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<LoginUseCase>()) {
    sl.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(sl<UserRepository>()),
    );
  }

  if (!sl.isRegistered<RegisterUseCase>()) {
    sl.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(sl<UserRepository>()),
    );
  }
  if(!sl.isRegistered<GetAllUsersUseCase>()){
    sl.registerLazySingleton<GetAllUsersUseCase>(
      () => GetAllUsersUseCase(sl<UserRepository>()),
    );
  }

  // Product dependencies
  if(!sl.isRegistered<LocalDataSource>()){
    sl.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImpl(appDatabase: sl<AppDatabase>())
    );
  }

if(!sl.isRegistered<ProductRepository>()){
  sl.registerLazySingleton<ProductRepository>(
    ()=> ProductRepositoryImpl(localDataSource: sl<LocalDataSource>())
  );
}
if (!sl.isRegistered<GetAllProductsUseCase>()) {
  sl.registerLazySingleton<GetAllProductsUseCase>(
    () => GetAllProductsUseCase(sl<ProductRepository>()),
  );
}

if (!sl.isRegistered<GetProductUseCase>()) {
  sl.registerLazySingleton<GetProductUseCase>(
    () => GetProductUseCase(sl<ProductRepository>()),
  );
}

if (!sl.isRegistered<CreateProductUseCase>()) {
  sl.registerLazySingleton<CreateProductUseCase>(
    () => CreateProductUseCase(sl<ProductRepository>()),
  );
}

if (!sl.isRegistered<UpdateProductUseCase>()) {
  sl.registerLazySingleton<UpdateProductUseCase>(
    () => UpdateProductUseCase(sl<ProductRepository>()),
  );
}

if (!sl.isRegistered<DeleteProductUseCase>()) {
  sl.registerLazySingleton<DeleteProductUseCase>(
    () => DeleteProductUseCase(sl<ProductRepository>()),
  );
}

  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory<AuthBloc>(
      () => AuthBloc(
        loginUseCase: sl<LoginUseCase>(),
        registerUseCase: sl<RegisterUseCase>(),
        getAllUsersUseCase: sl<GetAllUsersUseCase>()
      ),
    );
  }

  sl.registerFactory<ProductBloc>(
    () => ProductBloc(
      getAllProductsUseCase: sl<GetAllProductsUseCase>(),
       getProductUseCase: sl<GetProductUseCase>(),
        deleteProductUseCase: sl<DeleteProductUseCase>(),
         createProductUseCase: sl<CreateProductUseCase>(),
          updateProductUseCase: sl<UpdateProductUseCase>())
  );
}
