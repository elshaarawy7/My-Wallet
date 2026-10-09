import 'package:equatable/equatable.dart';
import 'package:my_wallet/features/transactions/data/models/get_transaction_model.dart';
import 'package:my_wallet/features/transactions/data/models/trendaction_model.dart';
import 'package:my_wallet/features/transactions/domain/entity/transaction_entity.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionDeleting extends TransactionState {}

class TransactionDeleted extends TransactionState {}

class TransactionDeleteFailure extends TransactionState {
  final String message;

  const TransactionDeleteFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class TransactionLoaded extends TransactionState {
  final GetTransactionModel transaction;
  const TransactionLoaded(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class TransactionsLoaded extends TransactionState {
  final List<TransactionModel> transactions;
  final Map<String, String> categoriesById;
  final String? categoryErrorMessage;

  const TransactionsLoaded(
    this.transactions, {
    this.categoriesById = const {},
    this.categoryErrorMessage,
  });

  double get totalExpenseBaseCurrencyAmount => transactions
      .where((transaction) => transaction.type == TransactionType.expense)
      .fold(
        0,
        (total, transaction) => total + transaction.baseCurrencyAmount,
      );

  @override
  List<Object?> get props => [transactions, categoriesById, categoryErrorMessage];
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}