import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class UserRepository {
  // for registeration
  Future<Either<Failure, void>> signUp(UserEntity user);

  // for login to account
  Future<Either<Failure, UserEntity>> signIn(String email, String password);

  // get all users that have an account
  Future<Either<Failure, List<UserEntity>>> getAllUsers();
}