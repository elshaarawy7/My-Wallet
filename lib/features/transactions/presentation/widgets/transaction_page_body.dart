import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:my_wallet/features/transactions/presentation/widgets/total_expanse_card.dart';
import 'package:my_wallet/features/transactions/presentation/widgets/transaction_item_card.dart';

class TransactionPageBody extends StatefulWidget {
  const TransactionPageBody({super.key});

  @override
  State<TransactionPageBody> createState() => _TransactionPageBodyState();
}

class _TransactionPageBodyState extends State<TransactionPageBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Gap(50),

            TotalExpenseCard(),

            Gap(10),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "تابع مصروفاتك ",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Gap(10),

            ListViewBuilderTransactionCard(),

            // Add your form fields and buttons here
          ],
        ),
      ),
    );
  }
}
