import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:fpdart/fpdart.dart';


abstract class UserLocalDataSource {
  Future<Either<Failure, void>> register(UserModel user);
  Future<Either<Failure,UserModel>> login(String email, String password);
  Future<Either<Failure, List<UserModel>>> getAllUsers();
  Future<Either<Failure, void>> updateUser(UserModel user);
  }