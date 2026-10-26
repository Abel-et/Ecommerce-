import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';


class UserModel extends UserEntity{
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.password,
    required super.createdAt,
  });

// when data comes form sql and conveted to model (sql => model)
  factory UserModel.fromSql(Map<String, dynamic> map){
    return UserModel(
      id: map['id'] as String, 
      fullName: map['name'] as String, 
      email: map['email']as String, 
      password: map['password'] as String, 
      createdAt: DateTime.parse(map['createdAt'] as String) 
      );
  }

  // when data comes form model and convet to sql (model => sql)
  Map<String, dynamic> UserModelToSql(){
    return {
      'id': id,
      'name': fullName,
      'email': email,
      'passowrd_hash': password,
      'created_at': createdAt
    };
  }

  // when data comes from entity and convert into model (Entity => model)
  factory UserModel.fromEntity(UserEntity user){
    return UserModel(id: user.id, fullName: user.fullName, email: user.email, password: user.password, createdAt: user.createdAt);
  }


  // convert form model to entity (Model => Entity)
  UserEntity toEntity(){
    return UserEntity(id: id, fullName: fullName, password: password, email: email, createdAt: createdAt);
  }

}