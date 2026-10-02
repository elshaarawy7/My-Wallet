// core/errors/failures.dart

/// Base failure used across the application.
abstract class Failure {
  final String message;

  const Failure(this.message);
}

/// Server/API failure.
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required String message,
    this.statusCode,
  }) : super(message);
}

/// No internet connection.
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'No internet connection',
  }) : super(message);
}

/// Request timeout.
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String message = 'Request timed out',
  }) : super(message);
}

/// Unauthorized request.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    String message = 'Unauthorized request',
  }) : super(message);
}

/// Resource not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = 'Resource not found',
  }) : super(message);
}

/// Validation failure.
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure({
    required String message,
    this.errors,
  }) : super(message);
}

/// Local storage/cache failure.
class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Cache error occurred',
  }) : super(message);
}