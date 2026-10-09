class ApiConstants {
  static const String baseUrl = 'https://money-manager.runasp.net/api/v1';

  // auth
  static const String login = '/auth/login';
  static const String regester = '/auth/signup';
  static const String googleAuth = '/auth/google';

  // transactions
  static const String createTransaction = '/transactions'; 
  static const String deleteTransaction = '/transactions';
  static const String categories = '/categories';
  static const String getTransactions = '/transactions';
}
