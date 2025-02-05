import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final _storage = const FlutterSecureStorage();
  static String? _refreshTokenPromise;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: 'id_token');
    final accessToken = await _storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = token;
      options.headers['accessToken'] = accessToken;
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final newToken = await _refreshToken();
      if (newToken != null) {
        await _storage.write(key: 'id_token', value: newToken);
        err.requestOptions.headers['Authorization'] = newToken;
        return handler.resolve(await Dio().fetch(err.requestOptions));
      }
    }
    return handler.next(err);
  }

  Future<String?> _refreshToken() async {
    if (_refreshTokenPromise != null) return _refreshTokenPromise;
    _refreshTokenPromise = await _fetchNewToken();
    return _refreshTokenPromise;
  }

  Future<String?> _fetchNewToken() async {
    // Implementar lógica de refresco del token
    return null;
  }
}