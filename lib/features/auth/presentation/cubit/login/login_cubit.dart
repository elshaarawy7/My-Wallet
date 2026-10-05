import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/auth/domain/repositories/auth_repo.dart';
import 'package:my_wallet/features/auth/presentation/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authRepo) : super(LoginInitial());
  final AuthRepo authRepo; 
  static LoginCubit get(context)=> BlocProvider.of<LoginCubit>(context);
  TextEditingController emailController = TextEditingController(); 
  TextEditingController passwordController = TextEditingController();  
  bool visibilty = false ; 
    
  Future<void> login() async { 
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      emit(LoginError(failure: const ServerFailure(message: "برجاء إدخال جميع البيانات"))); 
      return;
    }
    emit(LoginLoading()); 
    try {
      final res = await authRepo.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      res.fold(
        (failure) => emit(LoginError(failure: failure)),
        (loginModel) => emit(LoginSucsess(loginModel: loginModel)),
      );
    } catch (e) {
      emit(LoginError(failure: ServerFailure(message: "حدث خطأ ما: ${e.toString()}")));
    }
  }
}
