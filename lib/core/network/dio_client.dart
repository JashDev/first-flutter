import 'package:dio/dio.dart';
import '../config/environment_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/log_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dioAuthenticated;
  late final Dio dioUnauthenticated;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dioAuthenticated = Dio(BaseOptions(
      baseUrl: EnvironmentConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Platform': 'mobile',
        'Talfi': 'B2BService',
      },
    ));
    dioAuthenticated.interceptors.add(AuthInterceptor());
    dioAuthenticated.interceptors.add(LoggingInterceptor());

    dioUnauthenticated = Dio(BaseOptions(
      baseUrl: EnvironmentConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Platform': 'mobile',
        'Talfi': 'B2BService',
      },
    ));
    dioUnauthenticated.interceptors.add(LoggingInterceptor());
  }
}
