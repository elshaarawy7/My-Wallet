import 'package:equatable/equatable.dart';

enum TransactionType {
  expense,
  income;

  factory TransactionType.fromString(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => TransactionType.expense,
    );
  }
}

class TransactionEntity extends Equatable {
  final String id;
  final TransactionType type;
  final String categoryId;
  final String currencyCode;
  final double amount;
  final double exchangeRate;
  final double baseCurrencyAmount;
  final String description;
  final DateTime transactionDate;

  const TransactionEntity({
    required this.id,
    required this.type,
    required this.categoryId,
    required this.currencyCode,
    required this.amount,
    required this.exchangeRate,
    required this.baseCurrencyAmount,
    required this.description,
    required this.transactionDate,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        categoryId,
        currencyCode,
        amount,
        exchangeRate,
        baseCurrencyAmount,
        description,
        transactionDate,
      ];
}