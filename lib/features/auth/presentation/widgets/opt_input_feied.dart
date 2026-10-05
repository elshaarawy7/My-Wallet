import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInputField extends StatelessWidget {
  final Function(String)? onCompleted;

  const OtpInputField({super.key, this.onCompleted});

  @override
  Widget build(BuildContext context) {
    // التصميم الافتراضي للخانة
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5), // لون خلفية فاتح
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
    );

    // التصميم أثناء الوقوف/الكتابة في الخانة
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xFF2563FF), width: 2), // اللون الأزرق للمحيط
      ),
    );

    return Material(
      child: Pinput(
        length: 6, // عدد الأرقام
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        onCompleted: onCompleted, // ينفذ كود عند إكمال الـ 6 أرقام
      ),
    );
  }
}