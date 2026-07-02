import 'package:dio/dio.dart';
import 'package:flutter_movies_challenge/core/error/failure.dart';

Failure mapDioExceptionToFailure(DioException exception) {
  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.connectionError =>
      const NetworkFailure(),
    DioExceptionType.badResponse => _mapBadResponse(exception),
    DioExceptionType.cancel ||
    DioExceptionType.badCertificate ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.unknown =>
      const UnknownFailure(),
  };
}

Failure _mapBadResponse(DioException exception) {
  final statusCode = exception.response?.statusCode;
  return switch (statusCode) {
    401 || 403 => const UnauthorizedFailure(),
    404 => const NotFoundFailure(),
    _ => ServerFailure(
        exception.response?.statusMessage ?? 'Server error.',
        statusCode: statusCode,
      ),
  };
}
