import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:my_wallet/core/theme/app_color.dart';
import 'package:my_wallet/features/transactions/domain/entity/transaction_entity.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_cubit.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_state.dart';
import 'package:my_wallet/features/transactions/presentation/widgets/delete_transaction_dialog.dart';

class ListViewBuilderTransactionCard extends StatelessWidget {
  const ListViewBuilderTransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
        if (state is TransactionDeleteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
            ),
          );
          context.read<TransactionCubit>().fetchTransactions();
        }
        if (state is TransactionDeleted) {
          Fluttertoast.showToast(
            msg: "تم حذف المعاملة بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          context.read<TransactionCubit>().fetchTransactions();
        }
        if (state is TransactionsLoaded && state.categoryErrorMessage != null) {
          Fluttertoast.showToast(
            msg: state.categoryErrorMessage!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColors.errorColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      builder: (context, state) {
        if (state is TransactionLoading ||
            state is TransactionDeleting ||
            state is TransactionDeleted ||
            state is TransactionDeleteFailure) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is TransactionError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.errorColor),
              ),
            ),
          );
        }

        if (state is TransactionLoaded) {
          final transaction = state.transaction;
          final isExpense = transaction.type.toLowerCase() == 'expense';
          final amount =
              '${NumberFormat('#,##0.##').format(transaction.amount)} ${transaction.currencyCode}';

          return TransactionItemCard(
            title: transaction.description.isNotEmpty
                ? transaction.description
                : 'معاملة',
            category: isExpense ? 'مصروف' : 'دخل',
            time: DateFormat.yMMMd().add_jm().format(
              transaction.transactionDate.toLocal(),
            ),
            amount: amount,
            isExpense: isExpense,
          );
        }

        if (state is TransactionsLoaded) {
          if (state.transactions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('لا توجد معاملات حتى الآن'),
              ),
            );
          }

          return Column(
            children: state.transactions.map((transaction) {
              final isExpense = transaction.type == TransactionType.expense;
              final amount =
                  '${NumberFormat('#,##0.##').format(transaction.amount)} ${transaction.currencyCode}';

              return TransactionItemCard(
                title: transaction.description.isNotEmpty
                    ? transaction.description
                    : 'معاملة',
                category:
                    state.categoriesById[transaction.categoryId] ??
                    'تصنيف غير معروف',
                time: DateFormat.yMMMd().add_jm().format(
                  transaction.transactionDate.toLocal(),
                ),

                // Display the formatted amount with currency code
                amount: amount,
                isExpense: isExpense,
                onDelete: () => showDeleteTransactionDialog(
                  context,
                  transactionId: transaction.id,
                ),
              );
            }).toList(), 

            
          );
        }

        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('لم يتم اختيار معاملة لعرضها'),
          ),
        );
      },
    );
  }
}

class TransactionItemCard extends StatelessWidget {
  final String title;
  final String category;
  final String time;
  final String amount;
  final bool isExpense;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TransactionItemCard({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    required this.isExpense,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final amountColor = isExpense ? AppColors.errorColor : Colors.green;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF8C9EFF).withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isExpense ? Icons.arrow_outward : Icons.south_west,
            color: amountColor,
            size: 24,
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(4),
                Text(
                  '$category\n ${isExpense ? 'مصروف' : 'دخل'} • $time',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          const Gap(12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                tooltip: 'حذف المعاملة',
                onPressed: onDelete,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints.tightFor(
                  width: 36,
                  height: 36,
                ),
                color: AppColors.errorColor,
                icon: const Icon(Icons.delete_outline, size: 20),
              ), 
              
            ],
          ),
        ],
      ),
    );
  }
}
