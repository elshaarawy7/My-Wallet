import 'package:flutter/material.dart';
import 'package:my_wallet/core/theme/app_color.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  static const String routeName = '/transactionsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.background, 
    );
  }
}