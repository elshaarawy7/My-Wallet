import 'package:flutter/material.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/auth/presentation/widgets/regester_page_body.dart';

class RegesterPage extends StatelessWidget {
  const RegesterPage({super.key}); 

  static const String routeName = "RegesterPage" ;

  @override
  Widget build(BuildContext context) {
    return  RegisterPageBody();
     }
}