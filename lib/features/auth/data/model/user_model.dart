import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:ecommerce/features/auth/domain/entities/user_image_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.password,
    required super.createdAt,
    super.profileImage,
  });

  // when data comes form sql and conveted to model (sql => model)
  factory UserModel.fromSql(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      fullName: map['name'] as String,
      email: map['email'] as String,
      password: map['password_hash'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      profileImage: map['profile_image_path'] == null
          ? null
          : UserImageEntity(path: map['profile_image_path'] as String),
    );
  }

  // when data comes form model and convert to sql (model => sql)
  Map<String, dynamic> toSql() {
    return {
      'id': id,
      'name': fullName,
      'email': email,
      'password_hash': password,
      'created_at': createdAt.toIso8601String(),
      'profile_image_path': profileImage?.path,
    };
  }

  // when data comes from entity and convert into model (Entity => model)
  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      password: user.password,
      createdAt: user.createdAt,
      profileImage: user.profileImage,
    );
  }

  // convert form model to entity (Model => Entity)
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      password: password,
      email: email,
      createdAt: createdAt,
      profileImage: profileImage,
    );
  }
}
