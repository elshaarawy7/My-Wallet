import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/auth/presentation/widgets/opt_input_feied.dart';

class VerifyAccountPageBody extends StatelessWidget {
  const VerifyAccountPageBody({super.key}); 


  @override
  Widget build(BuildContext context) { 
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [  
            const Gap(80),

            Text(
              "تاكيد الحساب",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ), 

            const Gap(16), 

            Text(
              "أدخل رمز التحقق المكون من 6 أرقام الذي تم إرساله إلى بريدك الإلكتروني",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ), 

            const Gap(32),

            OtpInputField(
              onCompleted: (pin) {
                debugPrint(pin);
              },
            ),
          ],
        ),
      ),
    );

      

      
    
  }
}