import 'package:my_wallet/features/auth/domain/entity/login_entity.dart';

class LoginModel implements LoginEntity {
  final String? name;
  final String? email;
  final String? password;

  LoginModel({this.name, this.email, this.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : json;
    return LoginModel(
      name: (userData['name'] ?? userData['fullName'] ?? userData['username'])
          ?.toString(),
      email: userData['email']?.toString(),
      password: userData['password']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
  };
}
