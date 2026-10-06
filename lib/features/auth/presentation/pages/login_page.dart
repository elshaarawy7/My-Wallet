import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/core/server/getit_server.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/auth/presentation/cubit/google/googole_cubit.dart';
import 'package:my_wallet/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:my_wallet/features/auth/presentation/widgets/login_page_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String routerName = '/loginPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => gitIt<LoginCubit>(),
          ),
          BlocProvider(
            create: (context) => gitIt<GoogoleCubit>(),
          ),
        ],
        child: LoginPageBody(),
      ),
    );
  }
}
