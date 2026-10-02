import 'package:go_router/go_router.dart';
import 'package:my_wallet/features/auth/presentation/pages/login_page.dart';
import 'package:my_wallet/features/splash/presentation/pages/splash_page.dart';

class AppRouter {

  static const String splashPage = '/splashPage' ; 
  static const String loginPage = '/loginPage' ;

  static final  GoRouter router = GoRouter( 
    initialLocation: splashPage , 
    routes: [ 

      GoRoute(
        path: splashPage , 
         builder: (context, state) => SplashPage() ,
      ) ,  

      GoRoute(
        path: loginPage , 
         builder: (context, state) => LoginPage() ,
      ) , 

      

    ]
  );
}