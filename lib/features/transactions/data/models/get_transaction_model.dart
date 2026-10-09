
import 'package:my_wallet/features/transactions/domain/entity/get_reansaction_entity.dart';

class GetTransactionModel extends GatTransactionEntity {
  const GetTransactionModel({
    required super.id,
    required super.type,
    required super.categoryId,
    required super.currencyCode,
    required super.amount,
    required super.exchangeRate,
    required super.baseCurrencyAmount,
    required super.description,
    required super.transactionDate,
  });

  factory GetTransactionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return GetTransactionModel(
      id: data['id'] ?? '',
      type: data['type'] ?? '',
      categoryId: data['categoryId'] ?? '',
      currencyCode: data['currencyCode'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      exchangeRate: (data['exchangeRate'] as num).toDouble(),
      baseCurrencyAmount: (data['baseCurrencyAmount'] as num).toDouble(),
      description: data['description'] ?? '',
      transactionDate: DateTime.parse(data['transactionDate']),
    );
  }
}