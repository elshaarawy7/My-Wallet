import 'package:dartz/dartz.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/auth/data/models/login_model.dart';
import 'package:my_wallet/features/auth/data/models/regester_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, LoginModel>> login({
    required String email,
    required String password,
  });

  
  Future<Either<Failure, RegesterModel>> register({
    required String name, 
    required String email, 
    required String password , 
    required String confirmPassword , 
  }); 
}