import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/auth/data/models/login_model.dart';

class LoginState {} 

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {} 

class LoginSucsess extends LoginState {
  final LoginModel loginModel ;

  LoginSucsess({required this.loginModel});  

} 

class LoginError extends LoginState {
  final Failure failure ;

  LoginError({required this.failure});  
}  

  