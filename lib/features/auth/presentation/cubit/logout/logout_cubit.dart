import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/auth/data/models/login_model.dart';
import 'package:my_wallet/features/auth/presentation/cubit/login/login_state.dart';
import 'package:my_wallet/features/auth/presentation/cubit/logout/logout_stat.dart' show LogoutSuccess, LogoutInitial, LogoutState, LogoutLoading, LogoutError;

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial()); 

  static LogoutCubit get(context) => BlocProvider.of<LogoutCubit>(context); 

   Future<void> logout() async {
    emit(LogoutLoading()); 
      
      try {
        // Simulate a logout operation
        await Future.delayed(Duration(seconds: 2)); // Simulating network delay
      } catch (e) {
        emit(LogoutError(failure: ServerFailure(message: "Logout failed: ${e.toString()}")));
      }
  }
}