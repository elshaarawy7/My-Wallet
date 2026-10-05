import 'package:flutter/material.dart';
import 'package:my_wallet/core/router/app_router.dart';
import 'package:my_wallet/core/server/getit_server.dart';

void main() {  

  WidgetsFlutterBinding.ensureInitialized(); 
  setupServer();
  runApp(const MyWallet());
}

class MyWallet extends StatelessWidget {
  const MyWallet({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( 
      debugShowCheckedModeBanner: false, 
      routerConfig: AppRouter.router,  
      builder: (context, child){
         return Directionality(
           textDirection: TextDirection.rtl,
           child: Material(
             color: Colors.transparent,
             child: child!,
           ),
         );
    },);
  }

}
