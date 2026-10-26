
class UserEntity {
  final String id;
  final String fullName;
  final String password;
  final String email;
  final DateTime createdAt ;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.password,
    required this.email,
    required this.createdAt,
  });
}