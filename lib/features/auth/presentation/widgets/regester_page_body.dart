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
import 'package:my_wallet/features/auth/presentation/cubit/regester/regester_cubit.dart';
import 'package:my_wallet/features/auth/presentation/cubit/regester/regester_state.dart';
import 'package:my_wallet/features/auth/presentation/widgets/custem_text_from_filed.dart';
import 'package:my_wallet/features/auth/presentation/widgets/google_batton.dart';

class RegisterPageBody extends StatefulWidget {
  const RegisterPageBody({super.key});

  @override
  State<RegisterPageBody> createState() => _RegisterPageBodyState();
}

class _RegisterPageBodyState extends State<RegisterPageBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegesterCubit, RegesterState>(
      listener: (context, state) {
        if (state is RegesterSuccess) {
          CherryToast.success(
            title: const Text("تم إنشاء الحساب بنجاح", style: TextStyle(color: Colors.white)),
            description: const Text("تم تسجيل الدخول بنجاح", style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.successColor,
            toastPosition: Position.bottom,
            toastDuration: Duration(seconds: 2),
          ).show(context);
          context.go(AppRouter.homePage);
        }

        if (state is RegesterErorr) {
          CherryToast.error(
            title: const Text("خطأ"),
            description: Text(state.erorrMessage , selectionColor: Colors.white,),
            backgroundColor: AppColors.errorColor,
            toastPosition: Position.bottom,
            toastDuration: Duration(seconds: 1),
          ).show(context);
        }
      },
      builder: (context, state) {
        final cubit = RegesterCubit.get(context);
        return SingleChildScrollView(
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
                            "الذكاء المالي الشخصي",
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
                              "اتصال مشفر",
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

                  Gap(40),

                  // ===== العنوان =====
                  Text(
                    "إنشاء حساب جديد",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(10),
                  Text(
                    "ابدأ رحلتك المالية مع محفظتي، سجّل بياناتك للبدء الآن.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  Gap(30),

                  // ===== الاسم بالكامل =====
                  CustomTextField(
                    label: "الاسم بالكامل",
                    hintText: "ادخل اسمك بالكامل",
                    prefixIcon: Icons.person_outline,
                    isPassword: false,
                    controller: cubit.nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء إدخال الاسم";
                      }
                      if (value.length < 3) {
                        return "الاسم قصير جداً";
                      }
                      return null;
                    },
                  ),

                  Gap(20),

                  // ===== البريد الإلكتروني =====
                  CustomTextField(
                    label: "البريد الإلكتروني",
                    hintText: "ادخل بريدك الإلكتروني",
                    prefixIcon: Icons.email_outlined,
                    isPassword: false,
                    controller: cubit.emailController,
                    validator: Validators.email,
                  ),

                  Gap(20),

                  // ===== كلمة المرور =====
                  CustomTextField(
                    label: "كلمة المرور",
                    hintText: "ادخل كلمة المرور",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: cubit.passwordController,
                    validator: Validators.password,
                  ),

                  Gap(20),

                  // ===== تأكيد كلمة المرور =====
                  CustomTextField(
                    label: "تأكيد كلمة المرور",
                    hintText: "أعد إدخال كلمة المرور",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: cubit.confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء تأكيد كلمة المرور";
                      }
                      if (value != cubit.passwordController.text) {
                        return "كلمتا المرور غير متطابقتين";
                      }
                      return null;
                    },
                  ),

                  Gap(25),

                  // ===== زر إنشاء الحساب =====
                  state is RegesterLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                      : CustomBatton(
                          text: "إنشاء حساب",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.register();
                            }
                          },
                        ),

                  Gap(20),

                  // ===== فاصل "أو" =====
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

                  // ===== زر جوجل =====
                  GoogleButton(onPressed: () {}),

                  Gap(20),

                  // ===== ليس لديك حساب؟ تسجيل الدخول =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "لديك حساب بالفعل؟",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "تسجيل الدخول",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Gap(16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
