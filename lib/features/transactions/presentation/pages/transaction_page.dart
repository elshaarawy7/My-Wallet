import 'package:flutter/material.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/transactions/presentation/widgets/transaction_page_body.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  static const String routeName = "/TransactionPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const TransactionPageBody(),
    );
  }
}
