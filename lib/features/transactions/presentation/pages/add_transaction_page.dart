import 'package:flutter/material.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/transactions/widgets/add_transaction_page_body.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  static const String routeName = "/addTransactionPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AddTransactionPageBody(),
    );
  }
}
