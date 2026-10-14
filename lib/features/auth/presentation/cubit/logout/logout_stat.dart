import 'package:my_wallet/core/errors/fuiler.dart';

class LogoutState {}  

class LogoutInitial extends LogoutState {} 
class LogoutLoading extends LogoutState {} 
class LogoutSuccess extends LogoutState {
  final void logout ;
  LogoutSuccess({required this.logout});
} 
class LogoutError extends LogoutState {
  final Failure failure ; 
  LogoutError({required this.failure});  
}
