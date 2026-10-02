import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key}); 

  static const String routerName = '/loginPage' ;

  @override
  Widget build(BuildContext context) {
    return  Scaffold( 
      body: SafeArea(child: Column(children: [])) ,
    );
  }
}