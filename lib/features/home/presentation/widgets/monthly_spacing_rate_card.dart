import 'package:flutter/material.dart';

class MonthlySpendingRateCard extends StatelessWidget {
  final double spendingPercentage; // نسبة الاستهلاك (مثلاً 0.31 لـ 31%)
  final String remainingPercentageText; // النص لنسبة المتبقي "باقي ٦٩%"
  final String descriptionText; // النص الوصفي

  const MonthlySpendingRateCard({
    Key? key,
    this.spendingPercentage = 0.31,
    this.remainingPercentageText = 'باقي ٦٩%',
    this.descriptionText = 'استخدمت ٣١% فقط من دخلك لشهر أكتوبر',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // إطار رمادي ناعم
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: العنوان والـ Badge والشعار
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Badge "تحت السيطرة الممتازة"
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF), // أزرق فاتح جدًا
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "'تحت السيطرة الممتازة'",
                  style: const TextStyle(
                    color: Color(0xFF3B82F6), // أزرق متوسط
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // العنوان الرئيسي والأيقونة
              Row(
                children: [
                  const Text(
                    'معدل الاستهلاك الشهري',
                    style: TextStyle(
                      color: Color(0xFF1F2937),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // أيقونة الدرع / الأمان
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFF6FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // الوصف والنص المتبقي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // نسبة المتبقي (باقي ٦٩%)
              Text(
                remainingPercentageText,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // نص الوصف (استخدمت ٣١%...)
              Text(
                descriptionText,
                style: const TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // شريط التقدم (Progress Bar)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: spendingPercentage,
              minHeight: 12,
              backgroundColor: const Color(
                0xFFE5E7EB,
              ), // الخلفية الرمادية للـ Progress
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF2563EB), // اللون الأزرق للتقدم
              ),
            ),
          ),
        ],
      ),
    );
  }
}
