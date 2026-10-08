import 'package:equatable/equatable.dart';
import 'package:my_wallet/features/transactions/domain/entity/transaction_entity.dart';

abstract class AddTransactionState extends Equatable {
  const AddTransactionState();

  @override
  List<Object?> get props => [];
}

class AddTransactionInitial extends AddTransactionState {}

class AddTransactionLoading extends AddTransactionState {}

class AddTransactionSuccess extends AddTransactionState {
  final TransactionEntity transaction;

  const AddTransactionSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class AddTransactionFailure extends AddTransactionState {
  final String message;

  const AddTransactionFailure(this.message);

  @override
  List<Object?> get props => [message];
}