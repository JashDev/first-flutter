import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiService {
  final Dio _dio;

  ApiService({bool requiresAuth = false})
      : _dio = requiresAuth ? DioClient().dioAuthenticated : DioClient().dioUnauthenticated;

  Future<Response> get(String endpoint, {Map<String, dynamic>? headers}) async {
    return await _dio.get(
      endpoint,
      options: Options(headers: headers),
    );
  }

  Future<Response> post(String endpoint, dynamic data, {Map<String, dynamic>? headers}) async {
    return await _dio.post(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response> put(String endpoint, dynamic data, {Map<String, dynamic>? headers}) async {
    return await _dio.put(
      endpoint,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response> delete(String endpoint, {Map<String, dynamic>? headers}) async {
    return await _dio.delete(
      endpoint,
      options: Options(headers: headers),
    );
  }
}