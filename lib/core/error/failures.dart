import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  
  const Failure({
    required this.message,
    this.statusCode,
  });
  
  @override
  List<Object?> get props => [message, statusCode];
}

// Server Failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

// Network Failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'عدم اتصال به اینترنت',
  }) : super(message: message);
}

// Cache Failures
class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'خطا در ذخیره‌سازی محلی',
  }) : super(message: message);
}

// Authentication Failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    String message = 'خطای احراز هویت',
    super.statusCode,
  }) : super(message: message);
}

// Authorization Failures
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    String message = 'دسترسی غیرمجاز',
    super.statusCode = 403,
  }) : super(message: message);
}

// Validation Failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
  });
}

// Not Found Failures
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String message = 'یافت نشد',
    super.statusCode = 404,
  }) : super(message: message);
}

// Unknown Failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    String message = 'خطای نامشخص',
  }) : super(message: message);
}

