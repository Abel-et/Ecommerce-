import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:ecommerce/features/auth/domain/repository/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class RegisterUseCase {
  final UserRepository repository;

  const RegisterUseCase(this.repository);

  Future<Either<Failure, void>> call(UserEntity user) async {
    return await repository.signUp(user);
  }
}

class LoginUseCase {
  final UserRepository repository;

  LoginUseCase(this.repository);
  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
  ) async {
    return await repository.signIn(email, password);
  }
}

class GetAllUsersUseCase {
  final UserRepository repository;

  GetAllUsersUseCase(this.repository);
  Future<Either<Failure, List<UserEntity>>> call() async {
    return await repository.getAllUsers();
  }
}

class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<Failure, void>> call(UserEntity user) {
    return repository.updateUser(user);
  }
}
