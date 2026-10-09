import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/transactions/data/datasources/transaction_datasource.dart';
import 'package:my_wallet/features/transactions/data/models/get_transaction_model.dart';
import 'package:my_wallet/features/transactions/data/models/trendaction_model.dart';
import 'package:my_wallet/features/transactions/domain/repositories/transactions_repo.dart';
import 'package:my_wallet/features/transactions/domain/entity/category_entity.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      return Right(await remoteDataSource.getCategories());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure());
      }
      return Left(
        ServerFailure(message: _extractErrorMessage(e.response?.data)),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'تعذر تحميل التصنيفات: $e'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionModel>>> getTransactions() async {
    try {
      return Right(await remoteDataSource.getTransactions());
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure());
      }
      return Left(
        ServerFailure(
          message: _extractErrorMessage(
            e.response?.data,
            fallbackMessage: e.message ?? 'تعذر تحميل المعاملات',
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'تعذر تحميل المعاملات: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await remoteDataSource.deleteTransaction(id);
      return const Right(null);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure());
      }
      return Left(
        ServerFailure(
          message: _extractErrorMessage(
            e.response?.data,
            fallbackMessage: e.message ?? 'تعذر حذف المعاملة',
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'تعذر حذف المعاملة: $e'));
    }
  }

  @override
  Future<Either<Failure, TransactionModel>> createTransaction({
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
      final result = await remoteDataSource.createTransaction(
        type: type,
        categoryId: categoryId,
        currencyCode: currencyCode,
        amount: amount,
        exchangeRate: exchangeRate,
        baseCurrencyAmount: baseCurrencyAmount,
        description: description,
        transactionDate: transactionDate,
      );

      return Right(result);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure());
      }

      // لا تكون استجابة الـ API دائماً كائن JSON؛ قد تكون نصاً أو صفحة HTML.
      // لذلك لا يمكن الوصول إليها بـ [] قبل التحقق من نوعها.
      final errorMessage = _extractErrorMessage(e.response?.data);
      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع: $e'));
    }
  }

  String _extractErrorMessage(
    dynamic responseData, {
    String fallbackMessage = 'حدث خطأ أثناء إضافة المعاملة',
  }) {
    if (responseData is Map) {
      final error = responseData['error'];
      final validationErrors =
          responseData['errors'] ??
          (error is Map ? error['errors'] ?? error['issues'] : null);
      final validationMessage = _formatValidationErrors(validationErrors);
      if (validationMessage != null) {
        return validationMessage;
      }

      if (error is Map) {
        final message = error['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      if (responseData['message'] is String) {
        return responseData['message'] as String;
      }
      if (error is String && error.isNotEmpty) {
        return error;
      }
    }

    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData;
    }

    return fallbackMessage;
  }

  String? _formatValidationErrors(dynamic errors) {
    if (errors is Map) {
      final details = <String>[];
      for (final entry in errors.entries) {
        final field = entry.key.toString();
        final value = entry.value;
        final messages = value is List
            ? value.map((message) => message.toString()).toList()
            : value is String
            ? [value]
            : value is Map && value['message'] is String
            ? [value['message'] as String]
            : <String>[];
        if (messages.isNotEmpty) {
          details.add('$field: ${messages.join(', ')}');
        }
      }
      return details.isEmpty ? null : details.join('\n');
    }

    if (errors is List) {
      final details = <String>[];
      for (final issue in errors) {
        if (issue is! Map) {
          continue;
        }
        final field =
            issue['field'] ?? issue['fieldName'] ?? issue['propertyName'];
        final message = issue['message'];
        if (message is String && message.isNotEmpty) {
          details.add(
            field is String && field.isNotEmpty ? '$field: $message' : message,
          );
        }
      }
      return details.isEmpty ? null : details.join('\n');
    }

    return null;
  }

  @override
  Future<Either<Failure, GetTransactionModel>> getTransactionById(
    String id,
  ) async {
    try {
      final result = await remoteDataSource.getTransactionById(id);
      return Right(result);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Left(ServerFailure(message: 'المعاملة غير موجودة'));
      } else if (e.response?.statusCode == 401) {
        return const Left(ServerFailure(message: 'غير مصرح بالوصول'));
      }
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ غير متوقع'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
