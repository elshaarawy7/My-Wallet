import 'package:flutter/material.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/auth/presentation/widgets/verify_account_page_body.dart';

class VerifyAccountPage extends StatelessWidget {
  const VerifyAccountPage({super.key}); 

  static const String routeName = '/verifyAccountPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: VerifyAccountPageBody()),
    ); 
  }
}