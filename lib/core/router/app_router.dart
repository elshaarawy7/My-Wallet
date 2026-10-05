import 'package:go_router/go_router.dart';
import 'package:my_wallet/features/auth/presentation/pages/login_page.dart';
import 'package:my_wallet/features/auth/presentation/pages/regester_page.dart';
import 'package:my_wallet/features/auth/presentation/pages/foreget_passowrd_page.dart';
import 'package:my_wallet/features/auth/presentation/pages/verify_account_page.dart';
import 'package:my_wallet/features/home/presentation/pages/home_page.dart';
import 'package:my_wallet/features/splash/presentation/pages/splash_page.dart';

class AppRouter { 


  // auth 
  static const String splashPage = '/splashPage' ; 
  static const String loginPage = '/loginPage' ;
  static const String regesterPage = '/regesterPage' ; 
  static const String forgetPassowrdPage = '/forgetPassowrdPage' ; 
  static const String verifyAccountPage = '/verifyAccountPage' ; 

  // home  

  static const String homePage = '/homePage' ;

  static final  GoRouter router = GoRouter( 
    initialLocation: splashPage, 
    routes: [ 

      GoRoute(
        path: splashPage , 
         builder: (context, state) => SplashPage() ,
      ) ,  

      GoRoute(
        path: loginPage , 
         builder: (context, state) => LoginPage() ,
      ) ,  

      GoRoute(
        path: regesterPage , 
         builder: (context, state) => RegesterPage() ,
      ) ,  

       GoRoute(
        path: homePage , 
         builder: (context, state) => HomePage() ,
      ) ,   

      GoRoute(
        path: forgetPassowrdPage , 
         builder: (context, state) => ForegetPassowrdPage() ,
      ) ,    

      GoRoute(
        path: verifyAccountPage , 
         builder: (context, state) => VerifyAccountPage() ,
      ) ,    

      

    ]
  );
}