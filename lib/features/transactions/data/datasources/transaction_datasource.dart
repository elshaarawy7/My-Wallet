import 'package:my_wallet/features/transactions/data/models/get_transaction_model.dart';
import 'package:my_wallet/features/transactions/data/models/trendaction_model.dart';
import 'package:my_wallet/features/transactions/data/models/category_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<TransactionModel>> getTransactions();

  Future<void> deleteTransaction(String id);

  Future<TransactionModel> createTransaction({
    required String type,
    required String categoryId,
    required String currencyCode,
    required double amount,
    required double exchangeRate,
    required double baseCurrencyAmount,
    required String description,
    required DateTime transactionDate,
  }); 

  Future<GetTransactionModel> getTransactionById(String id);
}