import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/core/server/getit_server.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/auth/presentation/cubit/regester/regester_cubit.dart';
import 'package:my_wallet/features/auth/presentation/widgets/regester_page_body.dart';

class RegesterPage extends StatelessWidget {
  const RegesterPage({super.key});

  static const String routeName = "RegesterPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocProvider(
        create: (context) => gitIt<RegesterCubit>(),
        child: RegisterPageBody(),
      ),
    );
  }
}
