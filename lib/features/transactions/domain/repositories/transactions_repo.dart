import 'package:dartz/dartz.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/transactions/data/models/get_transaction_model.dart';
import 'package:my_wallet/features/transactions/data/models/trendaction_model.dart';
import 'package:my_wallet/features/transactions/domain/entity/category_entity.dart';


abstract class TransactionRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();

  Future<Either<Failure, List<TransactionModel>>> getTransactions();

  Future<Either<Failure, void>> deleteTransaction(String id);

  Future<Either<Failure, TransactionModel>> createTransaction({
    required String type,
    required String categoryId,
    required String currencyCode,
    required double amount,
    required double exchangeRate,
    required double baseCurrencyAmount,
    required String description,
    required DateTime transactionDate,
  }); 

  Future<Either<Failure, GetTransactionModel>> getTransactionById(String id);
}