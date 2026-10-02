import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/core/router/app_router.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/core/utils/app_images.dart';
import 'package:my_wallet/core/utils/validators.dart';
import 'package:my_wallet/core/widgets/custom_batton.dart';
import 'package:my_wallet/features/auth/presentation/widgets/custem_text_from_filed.dart';
import 'package:my_wallet/features/auth/presentation/widgets/google_batton.dart';
import 'package:my_wallet/features/auth/presentation/widgets/no_acount.dart';

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(50),

                Row(
                  children: [
                    Image.asset(AppImages.logoApp, height: 50, width: 50),
                    Gap(5),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "محفظتي",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "الذكاء المالي الشخصي ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Container(
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: .20),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: Text(
                            "اتصال مشفر ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(50),

                Text(
                  "مرحبا بيك",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(10),
                Text(
                  "سجّل دخولك للوصول إلى تحليلات محفظتك ونشاطك اليومي.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                Gap(30),

                CustomTextField(
                  label: "البريد الإلكتروني",
                  hintText: "ادخل بريدك الإلكتروني",
                  prefixIcon: Icons.email_outlined,
                  isPassword: false,
                  controller: emailController,
                  validator: Validators.email,
                ),

                Gap(20),

                CustomTextField(
                  label: "كلمة المرور",
                  hintText: "ادخل كلمة المرور",
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  controller: passwordController,
                  validator: Validators.password,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'نسيت كلمة المرور؟',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                CustomBatton(
                  text: "تسجيل الدخول",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {}
                  },
                ),

                Gap(20),

                const Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.borderColor)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'أو',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.borderColor)),
                  ],
                ),

                Gap(10),

                GoogleButton(onPressed: () {}),

                Gap(10),

                NoAccountWidget(
                  onPressed: () {
                    context.push(AppRouter.regesterPage);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
