import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:my_wallet/core/constants/api_constants.dart';
import 'package:my_wallet/core/errors/fuiler.dart';
import 'package:my_wallet/features/auth/data/models/login_model.dart';
import 'package:my_wallet/features/auth/data/models/login_response_model.dart';
import 'package:my_wallet/features/auth/data/models/regester_model.dart';
import 'package:my_wallet/features/auth/data/datasources/datasources_auhe.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DatasourcesAuthImple implements DatasourcesAuhe {
  final Dio dio;
  final GoogleSignIn googleSignIn;

  DatasourcesAuthImple(this.dio, this.googleSignIn);

  String _translateErrorMessage(String rawMessage) {
    final lower = rawMessage.toLowerCase().trim();
    if (lower.contains("invalid credentials") ||
        lower.contains("not found") ||
        lower.contains("not_found")) {
      return "البريد الإلكتروني أو كلمة المرور غير صحيحة، أو أن الحساب غير مسجل";
    }
    if (lower.contains("already exists") ||
        lower.contains("already in use") ||
        lower.contains("duplicate") ||
        lower.contains("conflict")) {
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
        if (errMap['issues'] != null &&
            errMap['issues'] is List &&
            (errMap['issues'] as List).isNotEmpty) {
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
      return left(ServerFailure(message: "حدث خطأ غير متوقع: ${e.toString()}"));
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
      return left(ServerFailure(message: "حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> googleAuth({
    required String idToken,
  }) async {
    try {
      // Initialize must be called FIRST before authenticate
      await GoogleSignIn.instance.initialize(
        serverClientId: '385677323317-tvea2qae3gk98nc9su1n4o5phepiqqdh.apps.googleusercontent.com',
      );

      // This will show the account picker dialog to the user
      final GoogleSignInAccount account = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuthData =
          await account.authentication;
      final String? token = googleAuthData.idToken;

      if (token == null) {
        throw Exception('Google ID Token is null');
      }

      final res = await dio.post(
        ApiConstants.googleAuth,
        data: {
          "idToken": token,
          "deviceIdentifier": "mobile_device",
          "platform": "android",
        },
      );

      if (res.statusCode != 200) {
        return left(
          ServerFailure(message: "حدث خطأ غير متوقع: ${res.statusCode}"),
        );
      }

      final data = res.data as Map<String, dynamic>;

      // DEBUG: print full response to see structure
      debugPrint('=== Google Auth Response ===');
      debugPrint(data.toString());
      debugPrint('===========================');

      return right(LoginResponseModel.fromJson(data));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure(message: _extractErrorMessage(e)));
      }
      return left(ServerFailure(message: "حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }
}
