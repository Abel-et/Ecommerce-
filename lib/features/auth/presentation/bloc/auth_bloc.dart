import 'package:ecommerce/core/error/failures.dart';
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';


import 'auth_event.dart';
import 'auth_state.dart';
import 'package:ecommerce/features/auth/domain/use_case/user_use_case.dart';
import "package:flutter_bloc/flutter_bloc.dart";


class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase ; 
  final GetAllUsersUseCase getAllUsersUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getAllUsersUseCase
  }):super(AuthInitial()){
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<GetAllUsersEvent>(_onGetUser);

  }
Future<void> _onRegister(
  RegisterEvent event,
  Emitter<AuthState> emit,
) async {
  debugPrint('========== REGISTER STARTED ==========');

  emit(AuthLoading());

  final user = UserEntity(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    fullName: event.fullName,
    email: event.email.trim(),
    password: event.password,
    createdAt: DateTime.now(),
  );

  try {
    debugPrint('REGISTER EMAIL: ${user.email}');
    debugPrint('CALLING REGISTER USE CASE...');

    final result = await registerUseCase(user);

    result.fold(
      (failure) {
        debugPrint('REGISTER FAILED: ${failure.message}');
        emit(AuthFailureState(message: failure.message));
      },
      (_) {
        debugPrint('REGISTER USE CASE RETURNED SUCCESS');
        emit(Authnticated(user));
      },
    );
  } catch (error, stackTrace) {
    debugPrint('REGISTER EXCEPTION: $error');
    debugPrintStack(stackTrace: stackTrace);

    emit(
      AuthFailureState(
        message: 'Registration failed. Check the console.',
      ),
    );
  }}

Future <void> _onGetUser(
  GetAllUsersEvent event,
  Emitter<AuthState> emit
)async{
  final getUsers = await getAllUsersUseCase();

  getUsers.fold(  
    (faliure) => print('un able to get  users datat'),
    (usersEntities) {
      print('.......................AllUsers ........................');
      print('totla users ${usersEntities.length}');
      for(UserEntity user in usersEntities){
        print('Full Name : ${user.fullName}');
        print("Email : ${user.email}");
        print('password : ${user.password}');


        print('................... another User ...........................');
      }

    }
  );
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