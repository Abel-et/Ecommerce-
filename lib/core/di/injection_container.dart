
import 'package:get_it/get_it.dart';

import 'package:ecommerce/core/database/app_database.dart';
import 'package:ecommerce/features/auth/data/repository/user_repository_impl.dart';
import 'package:ecommerce/features/auth/domain/repository/user_repository.dart';
import 'package:ecommerce/features/auth/domain/use_case/user_use_case.dart';
import 'package:ecommerce/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecommerce/features/auth/data/data_sources/local/user_local_data_source.dart';
import 'package:ecommerce/features/auth/data/data_sources/local/user_local_data_source_impl.dart';
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

  if (!sl.isRegistered<AuthBloc>()) {
    sl.registerFactory<AuthBloc>(
      () => AuthBloc(
        loginUseCase: sl<LoginUseCase>(),
        registerUseCase: sl<RegisterUseCase>(),
      ),
    );
  }
}
