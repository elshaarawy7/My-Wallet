import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/home/presentation/widgets/balance_cart.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Gap(75)),

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

            SliverToBoxAdapter(child: Gap(10)),

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

            Gap(20),

            SliverToBoxAdapter(child: AccountBalanceCard()),
          ],
        ),
      ),
    );
  }
}
