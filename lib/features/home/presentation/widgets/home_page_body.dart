import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/home/presentation/widgets/balance_cart.dart';
import 'package:my_wallet/features/home/presentation/widgets/monthly_calendar_card.dart';
import 'package:my_wallet/features/home/presentation/widgets/monthly_spacing_rate_card.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverGap(50),

            SliverToBoxAdapter(
              child: Text(
                "مرحبا بك يا احمد 👋",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Text(
                "الدورة المالية الحالية لـ أكتوبر ٢٠٢٦",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: MonthlyCalendarCard(
                transactionDates: [
                  DateTime(2026, 10, 2),
                  DateTime(2026, 10, 3),
                  DateTime(2026, 10, 6),
                ],
              ),
            ),

            SliverGap(10),

            SliverToBoxAdapter(child: AccountBalanceCard()),
            SliverGap(10),
            SliverToBoxAdapter(child: MonthlySpendingRateCard()),
            SliverGap(10),
          ],
        ),
      ),
    );
  }
}
