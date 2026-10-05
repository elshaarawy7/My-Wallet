import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:my_wallet/core/constants/api_constants.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/auth/data/models/login_model.dart';
import 'package:my_wallet/features/auth/data/models/regester_model.dart';
import 'package:my_wallet/features/auth/data/datasources/datasources_auhe.dart';

class DatasourcesAuthImple implements DatasourcesAuhe {
  final Dio dio;

  DatasourcesAuthImple(this.dio);

  String _translateErrorMessage(String rawMessage) {
    final lower = rawMessage.toLowerCase().trim();
    if (lower.contains("invalid credentials") || lower.contains("not found") || lower.contains("not_found")) {
      return "البريد الإلكتروني أو كلمة المرور غير صحيحة، أو أن الحساب غير مسجل";
    }
    if (lower.contains("already exists") || lower.contains("already in use") || lower.contains("duplicate") || lower.contains("conflict")) {
      return "هذا البريد الإلكتروني مسجل بالفعل، يرجى تسجيل الدخول";
    }
    if (lower.contains("too small") && lower.contains("password")) {
      return "كلمة المرور يجب ألا تقل عن 6 أحرف";
    }
    if (lower.contains("validation failed")) {
      return "يرجى التأكد من صحة البيانات المدخلة";
    }
    return rawMessage;
  }

  String _extractErrorMessage(DioException e) {
    if (e.response?.data != null && e.response?.data is Map) {
      final data = e.response!.data as Map;
      if (data['error'] != null && data['error'] is Map) {
        final errMap = data['error'] as Map;
        if (errMap['issues'] != null && errMap['issues'] is List && (errMap['issues'] as List).isNotEmpty) {
          final issue = (errMap['issues'] as List).first;
          if (issue is Map && issue['message'] != null) {
            return _translateErrorMessage(issue['message'].toString());
          }
        }
        if (errMap['message'] != null) {
          return _translateErrorMessage(errMap['message'].toString());
        }
      }
      if (data['message'] != null) {
        return _translateErrorMessage(data['message'].toString());
      }
      if (data['title'] != null) {
        return _translateErrorMessage(data['title'].toString());
      }
    }
    if (e.message != null && e.message!.isNotEmpty) {
      return _translateErrorMessage(e.message!);
    }
    return "هناك مشكلة في الاتصال بالانترنت، حاول مرة أخرى";
  }

  @override
  Future<Either<Failure, LoginModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await dio.post(
        ApiConstants.login,
        data: {
          "email": email,
          "password": password,
          "deviceIdentifier": "mobile_device",
          "platform": "android",
        },
      );
      final data = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{};
      final userData = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      return right(LoginModel.fromJson(userData));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure(message: _extractErrorMessage(e)));
      }
      return left(
        ServerFailure(message: "حدث خطأ غير متوقع: ${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, RegesterModel>> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final res = await dio.post(
        ApiConstants.regester,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "confirm_password": confirmPassword,
          "deviceIdentifier": "mobile_device",
          "platform": "android",
          "baseCurrency": "EGP",
        },
      );
      final data = res.data is Map<String, dynamic>
          ? res.data as Map<String, dynamic>
          : <String, dynamic>{};
      final userData = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      return right(RegesterModel.fromJson(userData));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure(message: _extractErrorMessage(e)));
      }
      return left(
        ServerFailure(message: "حدث خطأ غير متوقع: ${e.toString()}"),
      );
    }
  }
}
