import 'package:flutter/material.dart';
import 'package:my_wallet/core/router/app_router.dart';
import 'package:my_wallet/core/utils/app_images.dart';

class SplashPageBody extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AppImages.splashScrean), 
        
      ],
    );
  }
}