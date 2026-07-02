import 'package:dio/dio.dart';
import 'package:flutter_movies_challenge/core/error/failure.dart';
import 'package:flutter_movies_challenge/core/network/network_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapDioExceptionToFailure', () {
    test('maps connection timeout to NetworkFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(mapDioExceptionToFailure(exception), isA<NetworkFailure>());
    });

    test('maps connectionError to NetworkFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );

      expect(mapDioExceptionToFailure(exception), isA<NetworkFailure>());
    });

    test('maps 401 response to UnauthorizedFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 401,
        ),
      );

      expect(mapDioExceptionToFailure(exception), isA<UnauthorizedFailure>());
    });

    test('maps 404 response to NotFoundFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 404,
        ),
      );

      expect(mapDioExceptionToFailure(exception), isA<NotFoundFailure>());
    });

    test('maps other bad responses to ServerFailure with status code', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 500,
        ),
      );

      final failure = mapDioExceptionToFailure(exception);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
    });

    test('maps cancel to UnknownFailure', () {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.cancel,
      );

      expect(mapDioExceptionToFailure(exception), isA<UnknownFailure>());
    });
  });
}
