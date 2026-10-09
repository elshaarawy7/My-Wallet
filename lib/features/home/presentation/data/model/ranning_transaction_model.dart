class RecurringTransactionModel {
  final String title;
  final double amount;
  final String categoryId;
  final String currencyCode;
  final String type; // "income" أو "expense"
  final String recurrence; // "monthly", "weekly", etc.
  final String startDate;
  final String? endDate;
  final bool isActive;

  RecurringTransactionModel({
    required this.title,
    required this.amount,
    required this.categoryId,
    this.currencyCode = "EGP",
    required this.type,
    this.recurrence = "monthly",
    required this.startDate,
    this.endDate,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "amount": amount,
      "categoryId": categoryId,
      "currencyCode": currencyCode,
      "type": type,
      "recurrence": recurrence,
      "startDate": startDate,
      if (endDate != null) "endDate": endDate,
      "isActive": isActive,
    };
  }
}