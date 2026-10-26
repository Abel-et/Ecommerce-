import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import 'package:ecommerce/features/auth/domain/use_case/user_use_case.dart';
import "package:flutter_bloc/flutter_bloc.dart";


class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase ; 

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase
  }):super(AuthInitial()){
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onRegister( 
    RegisterEvent event ,
    Emitter<AuthState> emit
  ) async{
    emit(AuthLoading());

  try{
     // now creating user entity object 
    final user = UserEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(), 
      fullName: event.fullName, 
      password: event.password, 
      email: event.email, 
      createdAt: DateTime.now());

    final result = await registerUseCase(user);

    result.fold(  
      (failure) => emit(AuthFailureState(message: failure.message)),
      (useEntity) => emit(Authnticated(user))
    );
    
  }catch(error){
   emit(AuthFailureState(message: 'something gone wrong , try again please'));
  }
   

  }


  Future<void> _onLogin(  
    LoginEvent event,
    Emitter<AuthState> emit
  ) async{

    try{
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);

    result.fold(  
      (failure) => emit(AuthFailureState(message: failure.message)),
    (ans) => emit(Authnticated(ans)));
   
    }catch(error){
      emit(AuthFailureState(message: 'Something went Wrong. Pleas try again'));

    }


  }


}