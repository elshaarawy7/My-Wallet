import 'package:flutter/material.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/auth/presentation/widgets/forget_passowrd_page_body.dart';

class ForegetPassowrdPage extends StatelessWidget {
  const ForegetPassowrdPage({super.key});

  static const String routeName = "ForegetPassowrdPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ForgetPassowrdPageBody(), 
      
    );
  }
}
