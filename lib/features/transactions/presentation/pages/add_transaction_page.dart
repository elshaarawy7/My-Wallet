import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/core/server/getit_server.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/categories_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/transaction_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/widgets/add_transaction_page_body.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  static const String routeName = "/addTransactionPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => gitIt<AddTransactionCubit>()),
          BlocProvider(
            create: (context) => gitIt<CategoriesCubit>()..loadCategories(),
          ),
        ],
        child: TransactionPageBody(),
      ),
    );
  }
}
