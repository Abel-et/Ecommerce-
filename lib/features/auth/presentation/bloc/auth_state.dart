
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState{}


class AuthLoading extends AuthState{}

class Authnticated extends AuthState { 
  final UserEntity user ; 

  Authnticated( this.user);
}


class AuthFailureState extends AuthState{
  final String message; 
  AuthFailureState({ required this.message});

}