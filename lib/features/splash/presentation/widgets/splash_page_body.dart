import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // أو يمكنك استخدام طريقة الملاحة الخاص بك (Navigator)
import 'package:my_wallet/core/router/app_router.dart';
import 'package:my_wallet/core/utils/app_images.dart';

class SplashPageBody extends StatefulWidget {
  const SplashPageBody({super.key});

  @override
  State<SplashPageBody> createState() => _SplashPageBodyState();
}

class _SplashPageBodyState extends State<SplashPageBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadingAnimation;

  @override
  void initState() {
    super.initState();

    // 1. إعداد الأنيميشن (Fade In)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadingAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(_animationController);

    // بدء الأنيميشن
    _animationController.forward();

    // 2. التوجيه والانتقال التلقائي بعد 3 ثوانٍ
    _navigateToNextPage();
  }

  void _navigateToNextPage() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // استبدل هذا بسطر الملاحة المناسب لك
       context.go(AppRouter.loginPage) ;
        // أو إذا كنت تستخدم Navigator العادي:
        // Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose
  () {
    _animationController.dispose(); // تنظيف المحرك للأنيميشن عند إغلاق الصفحة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على أبعاد الشاشة بالكامل
    final mediaQuery = MediaQuery.of(context).size;

    return SizedBox(
      width: mediaQuery.width,
      height: mediaQuery.height,
      child: FadeTransition(
        opacity: _fadingAnimation,
        child: Image.asset(
          AppImages.splashScrean,
          fit: BoxFit.cover, // ملء الشاشة بالكامل دون ترك حواف
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}