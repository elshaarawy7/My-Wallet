import 'package:flutter/material.dart';
import 'package:my_wallet/features/splash/presentation/widgets/splash_page_body.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key}); 

  static const String routerName = '/splashPage' ;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SplashPageBody() ,
    ) ;
  }
}