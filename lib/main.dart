import 'package:flutter/material.dart';

void main() {
  runApp(const MyWallet());
}

class MyWallet extends StatelessWidget {
  const MyWallet({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(builder: (context, child){
         return Directionality(
           textDirection: TextDirection.rtl,
           child: child!,
         );
    },);
  }

}
