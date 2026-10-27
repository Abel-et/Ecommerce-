

abstract class AuthEvent {}

class LoginEvent extends AuthEvent{
  final String email ;
  final String password ;

  LoginEvent({ 
    required this.email,
    required this.password
  });
}
class GetAllUsersEvent extends AuthEvent{
  GetAllUsersEvent();
}

class RegisterEvent extends AuthEvent{
  final String fullName;
  final String email;
  final String password ;

  RegisterEvent({
    required this.fullName,
    required this.email,
    required this.password,
  });
}