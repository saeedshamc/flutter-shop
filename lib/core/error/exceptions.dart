class ServerException implements Exception {
  final String message;
  final int? statusCode;
  
  const ServerException({
    required this.message,
    this.statusCode,
  });
  
  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class NetworkException implements Exception {
  final String message;
  
  const NetworkException({
    this.message = 'No internet connection',
  });
  
  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  
  const CacheException({
    this.message = 'Cache error',
  });
  
  @override
  String toString() => 'CacheException: $message';
}

class AuthenticationException implements Exception {
  final String message;
  final int? statusCode;
  
  const AuthenticationException({
    required this.message,
    this.statusCode,
  });
  
  @override
  String toString() => 'AuthenticationException: $message';
}

class AuthorizationException implements Exception {
  final String message;
  
  const AuthorizationException({
    this.message = 'Unauthorized access',
  });
  
  @override
  String toString() => 'AuthorizationException: $message';
}

class ValidationException implements Exception {
  final String message;
  
  const ValidationException({
    required this.message,
  });
  
  @override
  String toString() => 'ValidationException: $message';
}

class NotFoundException implements Exception {
  final String message;
  
  const NotFoundException({
    this.message = 'Not found',
  });
  
  @override
  String toString() => 'NotFoundException: $message';
}

