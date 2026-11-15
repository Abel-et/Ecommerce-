import 'package:ecommerce/core/database/app_database.dart';
// import 'package:ecommerce/core/error/exceptions.dart';
import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';

import 'user_local_data_source.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final AppDatabase appDatabase;

  UserLocalDataSourceImpl({required this.appDatabase});

  @override
  Future<Either<Failure, void>> register(UserModel user) async {
    try {
      final sqlFormat = user.toSql();
      await appDatabase.registerUser(sqlFormat);

      return const Right(null);
    } catch (error) {
      debugPrint('REGISTER REPOSITORY ERROR: $error');
      return Left(DatabaseFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> login(
    String email,
    String password,
  ) async {
    try {
      final loginSql = await appDatabase.loginUser(email, password);
      if (loginSql != null) {
        final toModel = UserModel.fromSql(loginSql);
        return Right(toModel);
      } else {
        return Left(AuthFailure('Invalid email or password.'));
      }
    } catch (error) {
      return Left(DatabaseFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getAllUsers() async {
    try {
      final allUsers = await appDatabase.getAllUsers();
      return Right(allUsers);
    } catch (error) {
      return Left(DatabaseFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(UserModel user) async {
    try {
      await appDatabase.updateUser(
        id: user.id,
        name: user.fullName,
        email: user.email,
        profileImagePath: user.profileImage?.path,
      );
      return const Right(null);
    } catch (error) {
      return Left(DatabaseFailure(error.toString()));
    }
  }
}
