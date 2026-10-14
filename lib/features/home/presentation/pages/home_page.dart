import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/core/router/app_router.dart';
import 'package:my_wallet/core/server/getit_server.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/auth/presentation/cubit/logout/logout_cubit.dart';
import 'package:my_wallet/features/auth/presentation/cubit/logout/logout_stat.dart';
import 'package:my_wallet/features/home/presentation/widgets/home_page_body.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/catogogry/categories_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/transaction/transaction_cubit.dart';

class HomePage extends StatelessWidget {
  final String? userName;

  const HomePage({super.key, this.userName});

  static const String routeName = '/homePage';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => gitIt<AddTransactionCubit>()),
        BlocProvider(
          create: (_) => gitIt<TransactionCubit>()..fetchTransactions(),
        ),
        BlocProvider(
          create: (_) => gitIt<CategoriesCubit>()..loadCategories(),
        ),
        BlocProvider(create: (_) => gitIt<LogoutCubit>()),
      ],
      child: BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Fluttertoast.showToast(
              msg: "Logout successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );

            context.push(AppRouter.loginPage);
          } else if (state is LogoutError) {
            Fluttertoast.showToast(
              msg: "Logout failed: ${state.failure.message}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        },
        builder: (context, state) {
          final logoutCubit = LogoutCubit.get(context);
          return Scaffold(
            drawer: Drawer(
              backgroundColor: AppColors.background,
              child: Column(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: AppColors.background),
                    child: const Center(
                      child: Text(
                        'My Wallet',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "تسجيل الخروج",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                        ),
                      ), 

                      state is LogoutLoading
                          ? Center(
                            child: const CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          )
                          : IconButton(
                              onPressed: () {
                                logoutCubit.logout();
                              },
                              icon: const Icon(Icons.logout, color: Colors.red),
                            ),
                      
                    ],
                  ),
                ],
              ),
            ),
            appBar: AppBar(backgroundColor: AppColors.background),
            backgroundColor: AppColors.background,
            body: HomePageBody(userName: userName),
          );
        },
      ),
    );
  }
}
