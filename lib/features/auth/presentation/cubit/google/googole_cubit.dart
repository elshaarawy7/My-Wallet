import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/features/auth/data/models/login_response_model.dart';
import 'package:my_wallet/features/auth/presentation/cubit/google/googole_state.dart';
import 'package:my_wallet/features/auth/domain/repositories/auth_repo.dart';

class GoogoleCubit extends Cubit<GoogoleState> { 
  GoogoleCubit(this.authRepo) : super(GoogoleState()); 

  final AuthRepo authRepo; 

  static GoogoleCubit get(context) => BlocProvider.of<GoogoleCubit>(context); 

  Future<void> googleAuth({required String idToken}) async {
    emit(GoogleAuthLoading());
    final result = await authRepo.googleAuth(idToken: idToken);
    result.fold((l) {
      emit(GoogleAuthError(message: l.message));
    }, (r) {
      emit(GoogleAuthSucsess(loginResponseModel: r));
    });
  } 
}