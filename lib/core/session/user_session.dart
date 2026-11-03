
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';

class UserSession {
  UserEntity? _currentUser;

  UserEntity? get currentUser => _currentUser;

  void setUser(UserEntity user){
    _currentUser = user;
  }

  void clearUser(){
    _currentUser = null;
  }
}