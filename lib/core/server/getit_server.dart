import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_wallet/core/network/dio_client.dart';
import 'package:my_wallet/features/auth/data/datasources/datasources_auth_imple.dart';
import 'package:my_wallet/features/auth/data/repositories/auth_repo_imple.dart';
import 'package:my_wallet/features/auth/domain/repositories/auth_repo.dart';
import 'package:my_wallet/features/auth/presentation/cubit/google/googole_cubit.dart';
import 'package:my_wallet/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:my_wallet/features/auth/presentation/cubit/regester/regester_cubit.dart';

final gitIt = GetIt.instance;

void setupServer() {
  // Register GoogleSignIn first so it can be injected into DatasourcesAuthImple
  gitIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn.instance);
  gitIt.registerLazySingleton<Dio>(() => DioClient().dio);
  gitIt.registerLazySingleton<DatasourcesAuthImple>(
    () => DatasourcesAuthImple(gitIt<Dio>(), gitIt<GoogleSignIn>()),
  );
  gitIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImple(gitIt<DatasourcesAuthImple>()),
  );
  gitIt.registerLazySingleton<LoginCubit>(
    () => LoginCubit(gitIt<AuthRepo>()),
  );

  gitIt.registerLazySingleton<RegesterCubit>(
    () => RegesterCubit(gitIt<AuthRepo>()),
  );

  gitIt.registerLazySingleton<GoogoleCubit>(
    () => GoogoleCubit(gitIt<AuthRepo>()),
  );
}
