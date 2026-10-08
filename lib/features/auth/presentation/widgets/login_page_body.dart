import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/core/router/app_router.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/core/utils/app_images.dart';
import 'package:my_wallet/core/utils/validators.dart';
import 'package:my_wallet/core/widgets/custom_batton.dart';
import 'package:my_wallet/features/auth/data/datasources/datasources_auth_imple.dart';
import 'package:my_wallet/features/auth/data/repositories/auth_repo_imple.dart';
import 'package:my_wallet/features/auth/presentation/cubit/google/googole_cubit.dart';
import 'package:my_wallet/features/auth/presentation/cubit/login/login_cubit.dart';
import 'package:my_wallet/features/auth/presentation/cubit/login/login_state.dart';
import 'package:my_wallet/core/widgets/custem_text_from_filed.dart';
import 'package:my_wallet/features/auth/presentation/widgets/google_batton.dart';
import 'package:my_wallet/features/auth/presentation/widgets/no_acount.dart';

class LoginPageBody extends StatefulWidget {
  const LoginPageBody({super.key});

  @override
  State<LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<LoginPageBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          CherryToast.error(
            title: const Text("خطأ", style: TextStyle(color: Colors.white)),
            description: Text(
              state.failure.message,
              selectionColor: Colors.white,
            ),
            backgroundColor: AppColors.errorColor,
            toastPosition: Position.bottom,
            toastDuration: Duration(seconds: 1),
          ).show(context);
        }

        if (state is LoginSucsess) {
          CherryToast.success(
            title: const Text(
              "تم بنجاح",
              style: TextStyle(color: Colors.white),
            ),
            description: const Text(
              "تم تسجيل الدخول بنجاح",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.successColor,
            toastPosition: Position.bottom,
            toastDuration: Duration(seconds: 2),
          ).show(context);

          context.go(AppRouter.rotePage);
        }
      },
      builder: (context, state) {
        final cubit = LoginCubit.get(context);
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
                      controller: cubit.emailController,
                      validator: Validators.email,
                    ),

                    Gap(20),

                    CustomTextField(
                      label: "كلمة المرور",
                      hintText: "ادخل كلمة المرور",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      controller: cubit.passwordController,
                      validator: Validators.password,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.push(AppRouter.forgetPassowrdPage);
                        },
                        child: const Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    state is LoginLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : CustomBatton(
                            text: "تسجيل الدخول",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.login();
                              }
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

                    GoogleButton(),
                   

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
      },
    );
  }
}
