import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/core/server/getit_server.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/widgets/transaction_page_body.dart';

class TransactionPage extends StatelessWidget {
  final String? transactionId;

  const TransactionPage({super.key, this.transactionId});

  static const String routeName = "/TransactionPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) {
          final cubit = gitIt<TransactionCubit>();
          final id = transactionId;
          if (id != null && id.isNotEmpty) {
            cubit.fetchTransaction(id);
          } else {
            cubit.fetchTransactions();
          }
          return cubit;
        },
        child: const TransactionPageBody(),
      ),
    );
  }
}
