import 'package:flutter/material.dart';
import 'package:my_wallet/features/home/presentation/widgets/home_page_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/homePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: HomePageBody());
  }
}
