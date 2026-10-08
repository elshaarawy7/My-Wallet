import 'package:my_wallet/features/transactions/domain/entity/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
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

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: TransactionType.fromString(json['type'] as String),
      categoryId: json['categoryId'] as String,
      currencyCode: json['currencyCode'] as String,
      amount: (json['amount'] as num).toDouble(),
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      baseCurrencyAmount: (json['baseCurrencyAmount'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      transactionDate: DateTime.parse(json['transactionDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'categoryId': categoryId,
      'currencyCode': currencyCode,
      'amount': amount,
      'exchangeRate': exchangeRate,
      'baseCurrencyAmount': baseCurrencyAmount,
      'description': description,
      'transactionDate': transactionDate.toIso8601String(),
    };
  }
}