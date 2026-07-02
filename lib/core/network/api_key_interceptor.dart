import 'package:dio/dio.dart';
import 'package:flutter_movies_challenge/core/config/env_config.dart';

class ApiKeyInterceptor extends Interceptor {
  ApiKeyInterceptor(this._envConfig);

  final EnvConfig _envConfig;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    switch (_envConfig.authMode) {
      case TmdbAuthMode.v3:
        options.queryParameters['api_key'] = _envConfig.apiKey;
      case TmdbAuthMode.v4:
        options.headers['Authorization'] =
            'Bearer ${_envConfig.readAccessToken}';
    }
    handler.next(options);
  }
}
