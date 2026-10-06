import 'package:my_wallet/features/auth/data/models/login_response_model.dart';

class GoogoleState {} 
class GoogleAuthState extends GoogoleState {}  
class GoogleAuthLoading extends GoogoleState {}  
class GoogleAuthError extends GoogoleState {
  final String message;  
  GoogleAuthError({required this.message}); 
} 
class GoogleAuthSucsess extends GoogoleState {
  final LoginResponseModel loginResponseModel ; 
  GoogleAuthSucsess({required this.loginResponseModel}); 
}