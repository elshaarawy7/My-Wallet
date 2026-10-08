import 'package:dartz/dartz.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/transactions/data/models/trendaction_model.dart';
import 'package:my_wallet/features/transactions/data/models/category_model.dart';


abstract class TransactionRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();

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
}