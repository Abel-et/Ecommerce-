
import 'user_image_entity.dart';

class UserEntity {
  final String id;
  final String fullName;
  final String password;
  final String email;
  final DateTime createdAt ;
  final UserImageEntity? profileImage;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.password,
    required this.email,
    required this.createdAt,
    this.profileImage,
  });

  UserEntity copyWith({
    String? fullName,
    String? email,
    UserImageEntity? profileImage,
  }) {
    return UserEntity(
      id: id,
      fullName: fullName ?? this.fullName,
      password: password,
      email: email ?? this.email,
      createdAt: createdAt,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}