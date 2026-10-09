import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_wallet/features/transactions/presentation/cubit/get_transaction/get_transaction_cubit.dart';
// استورد الملفات والألوان الخاصة بمشروعك هنا
// import 'path_to/app_colors.dart';
// import 'path_to/transaction_cubit.dart';

void showDeleteTransactionDialog(BuildContext context, {required String transactionId}) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    animType: AnimType.bottomSlide,
    title: 'حذف المعاملة',
    desc: 'هل أنت تأكد من حذف هذه المعاملة؟',
    btnCancelText: 'إلغاء',
    btnOkText: 'حذف',
    btnOkColor: Colors.red, // أو AppColors.errorColor
    btnOkOnPress: () async {
      await context.read<TransactionCubit>().deleteTransaction(transactionId);
    },
    btnCancelOnPress: () {},
  ).show();
}