import 'package:my_wallet/features/auth/domain/entity/regester_entity.dart';

class RegesterModel implements RegesterEntity {
   final String? name ; 
  final String? email ; 
  final String? password ;
   final String? confirmPassword ; 

  RegesterModel({this.name, this.email, this.password, this.confirmPassword});

   factory RegesterModel.fromJson(Map<String, dynamic> json) => RegesterModel(
    name: json["name"],
    email: json["email"],
    password: json["password"],
    confirmPassword: json["confirm_password"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "password": password,
    "confirm_password": confirmPassword,
  };
}