import 'package:go_router/go_router.dart';
import 'package:my_wallet/features/splash/presentation/pages/splash_page.dart';

class AppRouter {

  static const String splashPage = '/splashPage' ; 

  static final  GoRouter router = GoRouter(
    routes: [ 

      GoRoute(
        path: splashPage , 
         builder: (context, state) => SplashPage() ,
      ) , 

      

    ]
  );
}