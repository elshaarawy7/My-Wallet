import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_state.dart';

class AccountBalanceCard extends StatefulWidget {
  const AccountBalanceCard({Key? key}) : super(key: key);

  @override
  State<AccountBalanceCard> createState() => _AccountBalanceCardState();
}

class _AccountBalanceCardState extends State<AccountBalanceCard> {
  bool isHidden = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final transactions = state is TransactionsLoaded ? state : null;
        final formatter = NumberFormat('#,##0.##');
        final availableBalance = transactions == null
            ? '—'
            : formatter.format(transactions.availableBalance);
        final totalExpenses = transactions == null
            ? '—'
            : '${formatter.format(transactions.totalExpenseBaseCurrencyAmount)}-';
        final totalIncome = transactions == null
            ? '—'
            : '${formatter.format(transactions.totalIncomeBaseCurrencyAmount)}+';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF151928), Color(0xFF0F121C)],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row العلوية (زر إخفاء والرصيد المتاح)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // زر إخفاء
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isHidden = !isHidden;
                            });
                          },
                          icon: Icon(
                            isHidden ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ),
                        Text(
                          isHidden ? 'إخفاء' : 'إظهار',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // الرصيد المتاح مع النقطة الملونة
                  Row(
                    children: [
                      const Text(
                        'الرصيد المتاح',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2196F3), // النقطة الزرقاء
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(10),

              // قيمة الرصيد الأساسي
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'ج.م',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    isHidden ? '********' : availableBalance,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Gap(10),

              // القسم السفلي (إجمالي الدخل / إجمالي المصروفات)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // إجمالي المصروفات
                  _buildSubStat(
                    title: 'إجمالي المصروفات',
                    amount: isHidden ? '********' : totalExpenses,
                    icon: Icons.arrow_upward,
                    color: const Color(0xFFEF5350), // أحمر
                  ),

                  // خط فاصل بين القسمين
                  Container(height: 40, width: 1, color: Colors.white10),

                  // إجمالي الدخل
                  _buildSubStat(
                    title: 'إجمالي الدخل',
                    amount: isHidden ? '********' : totalIncome,
                    icon: Icons.arrow_downward,
                    color: const Color(0xFF42A5F5), // أزرق/سماوي
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ودجت فرعية لإعادة استخدامها في القسم السفلي
  Widget _buildSubStat({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'ج.م',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(width: 4),
            Text(
              amount,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
