import 'package:flutter/material.dart';
import 'package:my_wallet/features/auth/presentation/widgets/login_page_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key}); 

  static const String routerName = '/loginPage' ;

  @override
  Widget build(BuildContext context) {
    return  Scaffold( 
      body: LoginPageBody() ,
    );
  }
}