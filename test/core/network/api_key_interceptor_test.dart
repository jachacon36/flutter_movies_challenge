import 'package:dio/dio.dart';
import 'package:flutter_movies_challenge/core/config/env_config.dart';
import 'package:flutter_movies_challenge/core/network/api_key_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

void main() {
  late MockRequestInterceptorHandler handler;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  setUp(() {
    handler = MockRequestInterceptorHandler();
  });

  group('ApiKeyInterceptor', () {
    test('adds api_key query parameter in v3 mode', () {
      final envConfig = EnvConfig(
        environment: const {
          'TMDB_AUTH_MODE': 'v3',
          'TMDB_API_KEY': 'test-v3-key',
        },
      );
      final interceptor = ApiKeyInterceptor(envConfig);
      final options = RequestOptions(path: '/movie/popular');

      interceptor.onRequest(options, handler);

      final captured = verify(() => handler.next(captureAny())).captured;
      final result = captured.single as RequestOptions;
      expect(result.queryParameters['api_key'], 'test-v3-key');
      expect(result.headers.containsKey('Authorization'), isFalse);
    });

    test('adds Authorization Bearer header in v4 mode', () {
      final envConfig = EnvConfig(
        environment: const {
          'TMDB_AUTH_MODE': 'v4',
          'TMDB_API_READ_ACCESS_TOKEN': 'test-v4-token',
        },
      );
      final interceptor = ApiKeyInterceptor(envConfig);
      final options = RequestOptions(path: '/movie/popular');

      interceptor.onRequest(options, handler);

      final captured = verify(() => handler.next(captureAny())).captured;
      final result = captured.single as RequestOptions;
      expect(result.headers['Authorization'], 'Bearer test-v4-token');
      expect(result.queryParameters.containsKey('api_key'), isFalse);
    });

    test('throws when TMDB_AUTH_MODE is invalid', () {
      final envConfig = EnvConfig(
        environment: const {'TMDB_AUTH_MODE': 'bogus'},
      );
      final interceptor = ApiKeyInterceptor(envConfig);
      final options = RequestOptions(path: '/movie/popular');

      expect(
        () => interceptor.onRequest(options, handler),
        throwsStateError,
      );
    });
  });
}
