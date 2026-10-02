// core/errors/exceptions.dart

/// Base exception for all app exceptions.
abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

/// Server/API exception.
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required String message,
    this.statusCode,
  }) : super(message);
}

/// No internet connection.
class NetworkException extends AppException {
  const NetworkException({
    String message = 'No internet connection',
  }) : super(message);
}

/// Request timeout.
class TimeoutException extends AppException {
  const TimeoutException({
    String message = 'Request timed out',
  }) : super(message);
}

/// Unauthorized request - usually 401.
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = 'Unauthorized request',
  }) : super(message);
}

/// Resource not found - usually 404.
class NotFoundException extends AppException {
  const NotFoundException({
    String message = 'Resource not found',
  }) : super(message);
}

/// Validation error - usually 400.
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    required String message,
    this.errors,
  }) : super(message);
}

/// Local storage/cache exception.
class CacheException extends AppException {
  const CacheException({
    String message = 'Cache error occurred',
  }) : super(message);
}