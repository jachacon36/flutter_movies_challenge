import 'package:dio/dio.dart';
import 'package:flutter_movies_challenge/core/config/app_constants.dart';
import 'package:flutter_movies_challenge/core/config/env_config.dart';
import 'package:flutter_movies_challenge/core/network/api_key_interceptor.dart';

class DioClient {
  DioClient({required EnvConfig envConfig, Dio? dio})
      : _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = AppConstants.tmdbBaseUrl
      ..connectTimeout = AppConstants.connectTimeout
      ..receiveTimeout = AppConstants.receiveTimeout;
    _dio.interceptors.add(ApiKeyInterceptor(envConfig));
  }

  final Dio _dio;

  Dio get dio => _dio;
}
