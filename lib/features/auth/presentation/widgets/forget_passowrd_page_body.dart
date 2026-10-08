import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/core/router/app_router.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/core/utils/validators.dart';
import 'package:my_wallet/core/widgets/custom_batton.dart';
import 'package:my_wallet/core/widgets/custem_text_from_filed.dart';

class ForgetPassowrdPageBody extends StatefulWidget {
  const ForgetPassowrdPageBody({super.key});

  @override
  State<ForgetPassowrdPageBody> createState() => _ForgetPassowrdPageBodyState();
}

class _ForgetPassowrdPageBodyState extends State<ForgetPassowrdPageBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Gap(100),
            SizedBox(
              width: double.infinity,
              child: Text(
                "نسيت كلمة المرور",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: Text(
                "اكتب البريد الإلكتروني المرتبط بحسابك وهتوصلك رسالة فورية تتضمن رابطاً آمناً لإعادة تعيين كلمة المرور بكل سهولة.",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.right,
              ),
            ),
            Gap(50),
            CustomTextField(
              prefixIcon: Icons.email,
              label: 'البريد الإلكتروني',
              hintText: 'ادخل البريد الإلكتروني',
              validator: Validators.email,
              isPassword: false,
            ),

            Gap(50),
            CustomBatton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.push(AppRouter.verifyAccountPage);
                }
              },
              text: 'إرسال رابط إعادة التعيين',
            ),
          ],
        ),
      ),
    );
  }
}
