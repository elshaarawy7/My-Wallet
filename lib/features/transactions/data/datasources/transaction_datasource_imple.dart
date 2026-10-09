import 'package:dio/dio.dart';
import 'package:my_wallet/core/constants/api_constants.dart';
import 'package:my_wallet/features/transactions/data/datasources/transaction_datasource.dart';
import 'package:my_wallet/features/transactions/data/models/category_model.dart';
import 'package:my_wallet/features/transactions/data/models/get_transaction_model.dart';
import 'package:my_wallet/features/transactions/data/models/trendaction_model.dart';

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await dio.get(
      ApiConstants.categories,
      queryParameters: {
        'page': 1,
        'limit': 100,
        'sortBy': 'name',
        'sortOrder': 'asc',
      },
    );
    final responseData = response.data;
    if (responseData is! Map ||
        responseData['success'] != true ||
        responseData['data'] is! Map ||
        (responseData['data'] as Map)['data'] is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'تعذر قراءة التصنيفات من الخادم',
      );
    }

    final categories = ((responseData['data'] as Map)['data'] as List)
        .map(
          (category) => CategoryModel.fromJson(
            Map<String, dynamic>.from(category as Map),
          ),
        )
        .toList();

    const defaults = [
      ('أكل وشرب', 'restaurant', '#FF7043'),
      ('مواصلات', 'directions-car', '#42A5F5'),
      ('مشتريات', 'shopping-cart', '#AB47BC'),
      ('فواتير', 'receipt', '#FFA726'),
      ('أخرى', 'more-horiz', '#78909C'),
    ];
    for (final (name, icon, color) in defaults) {
      if (categories.any(
        (category) => _normalizeCategoryName(category.name) == name,
      )) {
        continue;
      }

      final created = await dio.post(
        ApiConstants.categories,
        data: {'name': name, 'icon': icon, 'color': color},
      );
      final createdData = created.data;
      if (createdData is! Map ||
          createdData['success'] != true ||
          createdData['data'] is! Map) {
        throw DioException(
          requestOptions: created.requestOptions,
          response: created,
          message: 'تعذر إنشاء التصنيف "$name"',
        );
      }
      categories.add(
        CategoryModel.fromJson(
          Map<String, dynamic>.from(createdData['data'] as Map),
        ),
      );
    }

    return categories;
  }

  String _normalizeCategoryName(String name) {
    final normalizedName = name
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .toLowerCase()
        .trim();
    if (normalizedName == 'اخرى' || normalizedName == 'other') {
      return 'أخرى';
    }
    return normalizedName;
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final response = await dio.get(
      ApiConstants.getTransactions,
      queryParameters: {'page': 1, 'limit': 100},
    );
    final responseData = response.data;

    if (responseData is! Map || responseData['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'تعذر قراءة المعاملات من الخادم',
      );
    }

    final data = responseData['data'];
    final transactions = data is List
        ? data
        : data is Map
        ? data['data'] ?? data['items'] ?? data['transactions']
        : responseData['items'] ?? responseData['transactions'];

    if (transactions is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'تنسيق قائمة المعاملات غير صالح',
      );
    }

    return transactions
        .map(
          (transaction) => TransactionModel.fromJson(
            Map<String, dynamic>.from(transaction as Map),
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final response = await dio.delete(
      '${ApiConstants.deleteTransaction}/${Uri.encodeComponent(id)}',
    );
    final responseData = response.data;

    if (responseData is Map &&
        responseData.containsKey('success') &&
        responseData['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: responseData['message'] is String
            ? responseData['message'] as String
            : 'تعذر حذف المعاملة',
      );
    }
  }

  @override
  Future<TransactionModel> createTransaction({
    required String type,
    required String categoryId,
    required String currencyCode,
    required double amount,
    required double exchangeRate,
    required double baseCurrencyAmount,
    required String description,
    required DateTime transactionDate,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.createTransaction,
        data: {
          'type': type,
          'categoryId': categoryId,
          'currencyCode': currencyCode,
          'amount': amount,
          'exchangeRate': exchangeRate,
          'baseCurrencyAmount': baseCurrencyAmount,
          'description': description,
          'transactionDate': transactionDate.toUtc().toIso8601String(),
        },
      );

      final responseData = response.data;

      // الـ API يرجع كائن داخلي باسم "data" يحتوي على تفاصيل المعاملة.
      // نتحقق من النوع أولاً لأن رد الخادم قد يكون نصاً عند حدوث خطأ.
      if (response.statusCode == 201 &&
          responseData is Map &&
          responseData['success'] == true &&
          responseData['data'] is Map) {
        return TransactionModel.fromJson(
          Map<String, dynamic>.from(responseData['data'] as Map),
        );
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: responseData is Map && responseData['message'] is String
              ? responseData['message'] as String
              : 'Failed to create transaction',
        );
      }
    } on DioException {
      rethrow; // يتم إعادة رمي الاستثناء ليتعامل معه الـ Repository
    } catch (e) {
      throw Exception('حدث خطأ في النظام : $e');
    }
  }

  @override
  Future<GetTransactionModel> getTransactionById(String id) async {
    final response = await dio.get('/transactions/$id');
    return GetTransactionModel.fromJson(response.data);
  }
}
