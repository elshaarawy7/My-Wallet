import 'package:my_wallet/features/auth/domain/entity/login_entity.dart';

class LoginModel implements LoginEntity {
  final String? email;
  final String? password;
  

  LoginModel({this.email, this.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };
}
