import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/features/auth/domain/repositories/auth_repo.dart';
import 'package:my_wallet/features/auth/presentation/cubit/regester/regester_state.dart';

class RegesterCubit extends Cubit<RegesterState> {
  RegesterCubit(this.authRepo) : super(RegesterInitial());

  final AuthRepo authRepo;

  static RegesterCubit get(context) => BlocProvider.of(context);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> register() async {
    emit(RegesterLoading());
    final result = await authRepo.register(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );
    result.fold(
      (failure) {
        emit(RegesterErorr(failure.message));
      },
      (r) {
        emit(RegesterSuccess(r));
      },
    );
  }
}
