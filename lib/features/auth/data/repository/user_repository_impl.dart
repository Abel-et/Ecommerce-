import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:fpdart/fpdart.dart';

import '../data_sources/local/user_local_data_source.dart';
import '../../domain/repository/user_repository.dart';
import '../../domain/entities/user_entity.dart';


class UserRepositoryImpl implements UserRepository{
  final UserLocalDataSource localDataSource ; 
  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure,void>> signUp( UserEntity user) async{
    try{
    final userModel = UserModel.fromEntity(user);
    await localDataSource.register(userModel);
    return Right(null);
  } 
  catch(error){
    return Left(AuthFailure('cause inside repository impl file ${error.toString()}'));
  }
  }

  @override
  Future<Either<Failure,UserEntity>> signIn( String email, String password) async{
    try{
      final result = await localDataSource.login(email, password);
      return result.map((userModel) => userModel.toEntity());
       }catch(error){
      return Left(AuthFailure('cause inside repository'));
    }
  }
}