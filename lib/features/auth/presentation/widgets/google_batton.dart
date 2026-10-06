import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wallet/core/router/app_router.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/core/utils/app_images.dart';
import 'package:my_wallet/features/auth/presentation/cubit/google/googole_cubit.dart';
import 'package:my_wallet/features/auth/presentation/cubit/google/googole_state.dart';

class GoogleButton extends StatelessWidget {

  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoogoleCubit, GoogoleState>(
      listener: (context, state) {  

         if (state is GoogleAuthError) {
          CherryToast.error(
            title: const Text("خطأ", style: TextStyle(color: Colors.white)),
            description: Text(
              state.message ,
              selectionColor: Colors.white,
            ),
            backgroundColor: AppColors.errorColor,
            toastPosition: Position.bottom,
            toastDuration: Duration(seconds: 2),
          ).show(context);
        } 

         if (state is GoogleAuthSucsess) {
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
          context.go(AppRouter.homePage);
        }
        
      },
      builder: (context, state) { 

         final cubit = GoogoleCubit.get(context) ; 
         
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: state is GoogleAuthLoading
              ? null
              : () {
                  cubit.googleAuth(idToken: '');
                },
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.googleIcon, width: 24, height: 24),
      
              const Gap(8),
              const Text(
                'المتابعة باستخدام Google',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
      }
    );
  }
}
