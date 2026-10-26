import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> signUp(UserEntity user);
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
}