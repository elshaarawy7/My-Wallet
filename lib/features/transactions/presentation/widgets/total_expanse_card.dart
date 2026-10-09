import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_state.dart';

class TotalExpenseCard extends StatelessWidget {
  const TotalExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C323B), // لون الخلفية الداكنة
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6B2D39), // لون خلفية الشارة (حمر داكن)
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "اجمالي المصروفات",
                style: const TextStyle(
                  color: Color(0xFFFFA3B1), // لون النص الوردي/الأحمر الفاتح
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const Gap(12),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "جنيه",
                style: const TextStyle(
                  color: Color(0xFFB0B7C3), // لون العملة الرمادي الفاتح
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              BlocBuilder<TransactionCubit, TransactionState>(
                builder: (context, state) {
                  final total = state is TransactionsLoaded
                      ? NumberFormat('#,##0.##')
                            .format(state.totalExpenseBaseCurrencyAmount)
                      : '—';

                  return Text(
                    total,
                    style: const TextStyle(
                      color: Color(0xFFFF5252),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
