import 'package:dartz/dartz.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/transactions/domain/entity/transaction_entity.dart';
import 'package:my_wallet/features/transactions/domain/repositories/transactions_repo.dart';


class CreateTransactionUseCase {
  final TransactionRepository repository;

  CreateTransactionUseCase(this.repository);

  Future<Either<Failure, TransactionEntity>> call({
    required String type,
    required String categoryId,
    required String currencyCode,
    required double amount,
    required double exchangeRate,
    required double baseCurrencyAmount,
    required String description,
    required DateTime transactionDate,
  }) async {
    return await repository.createTransaction(
      type: type,
      categoryId: categoryId,
      currencyCode: currencyCode,
      amount: amount,
      exchangeRate: exchangeRate,
      baseCurrencyAmount: baseCurrencyAmount,
      description: description,
      transactionDate: transactionDate,
    );
  }
}