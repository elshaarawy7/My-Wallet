import 'package:dartz/dartz.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/auth/data/models/login_model.dart';
import 'package:my_wallet/features/auth/data/models/regester_model.dart';
import 'package:my_wallet/features/auth/domain/repositories/auth_repo.dart';
import 'package:my_wallet/features/auth/data/datasources/datasources_auth_imple.dart';

class AuthRepoImple implements AuthRepo {
  final DatasourcesAuthImple datasourcesAuthImple;

  AuthRepoImple(this.datasourcesAuthImple);

  @override
  Future<Either<Failure, LoginModel>> login({
    required String email,
    required String password,
  }) async {
    return await datasourcesAuthImple.login(email: email, password: password);
  }

  @override
  Future<Either<Failure, RegesterModel>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await datasourcesAuthImple.register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
