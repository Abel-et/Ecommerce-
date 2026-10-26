import 'package:ecommerce/core/database/app_database.dart';
// import 'package:ecommerce/core/error/exceptions.dart';
import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/data/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'user_local_data_source.dart';

class UserLocalDataSourceImpl implements UserLocalDataSource{
  final AppDatabase appDatabase;

  UserLocalDataSourceImpl({ required this.appDatabase});


  @override
  Future<Either<Failure,void>> register(UserModel user) async{
    try{
      final sqlFormat = user.UserModelToSql();
      await appDatabase.registerUser(sqlFormat);

      return const Right(null);
    } catch(error){
      return Left(DatabaseFailure(error.toString()));
    }
  }

@override
  Future<Either<Failure, UserModel>> login(String email, String password) async{
    try{
      final loginSql = await appDatabase.loginUser(email, password); 
      if (loginSql != null){
         final toModel = UserModel.fromSql(loginSql);
      return Right(toModel);
      }else{
        return Left(AuthFailure('Invalid email or passowrd.'));
      }
     
        }catch(error){
          return Left(DatabaseFailure(error.toString()));
        }
  }
}